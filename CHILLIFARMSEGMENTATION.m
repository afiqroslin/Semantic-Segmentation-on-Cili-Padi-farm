imgDir = fullfile("D:\Work 2\SEM 8\Computer Vision\Assignment\Semantic-Segmentation\week2");
imds = imageDatastore(imgDir);

I = readimage(imds,1);
I = histeq(I);
imshow(I)

classes = [
    "Flat"
    "LivingThings"
    "Plantation"
    "Vegetation"
    "MiscellaneousObject"
    "Construction"
    "Nature"
    "Vehicle"
    "Sky"
    ];


labelIDs = chilliPixelLabelIDs();
labelDir = fullfile("D:\Work 2\SEM 8\Computer Vision\Assignment\Semantic-Segmentation\LabelledChilliFarm");
pxds = pixelLabelDatastore(labelDir,classes,labelIDs);

C = readimage(pxds,1);
cmap = chilliColorMap;
B = labeloverlay(I,C,'ColorMap',cmap);
imshow(B)
pixelLabelColorbar(cmap,classes);

tbl = countEachLabel(pxds);

frequency = tbl.PixelCount/sum(tbl.PixelCount);
figure
bar(1:numel(classes),frequency);
xticks(1:numel(classes)); 
xticklabels(tbl.Name);
xtickangle(45);
ylabel('Frequency');

[imdsTrain, imdsVal, imdsTest, pxdsTrain, pxdsVal, pxdsTest] = partitionChilliData(imds,pxds);
numTrainingImages = numel(imdsTrain.Files)
numValImages = numel(imdsVal.Files)
numTestingImages = numel(imdsTest.Files)

% Specify the network image size. This is typically the same as the traing image sizes.
imageSize = [1080 1920 3];

% Specify the number of classes.
numClasses = numel(classes);

% Create DeepLab v3+.
lgraph = deeplabv3plusLayers(imageSize, numClasses, "resnet18");

imageFreq = tbl.PixelCount ./ tbl.ImagePixelCount;
classWeights = median(imageFreq) ./ imageFreq;

pxLayer = pixelClassificationLayer('Name','labels','Classes',tbl.Name,'ClassWeights',classWeights);
lgraph = replaceLayer(lgraph,"classification",pxLayer);

% Define training options. 
% Define validation data.
dsVal = combine(imdsVal,pxdsVal);

% Define training options. 
options = trainingOptions('sgdm', ...
    'LearnRateSchedule','piecewise',...
    'LearnRateDropPeriod',10,...
    'LearnRateDropFactor',0.3,...
    'Momentum',0.9, ...
    'InitialLearnRate',1e-3, ...
    'L2Regularization',0.005, ...
    'ValidationData',dsVal,...
    'MaxEpochs',30, ...  
    'MiniBatchSize',8, ...
    'Shuffle','every-epoch', ...
    'CheckpointPath', tempdir, ...
    'VerboseFrequency',2,...
    'Plots','training-progress',...
    'ValidationPatience', 4);

dsTrain = combine(imdsTrain, pxdsTrain);

xTrans = [-10 10];
yTrans = [-10 10];
dsTrain = transform(dsTrain, @(data)augmentImageAndLabel(data,xTrans,yTrans));

doTraining = false;
if doTraining    
    [net, info] = trainNetwork(dsTrain,lgraph,options);
else
    pretrainedNetwork = fullfile("D:\Work 2\SEM 8\Computer Vision\Assignment\Semantic-Segmentation\chillinet1.mat");  
    data = load(pretrainedNetwork);
    net = data.net;
end

I = readimage(imdsTest,1);
C = semanticseg(I, net);

B = labeloverlay(I,C,'Colormap',cmap,'Transparency',0.4);
figure
imshow(B)
pixelLabelColorbar(cmap, classes);

expectedResult = readimage(pxdsTest,1);
actual = uint8(C);
expected = uint8(expectedResult);
figure
imshowpair(actual, expected)

iou = jaccard(C,expectedResult);
table(classes,iou)

pxdsResults = semanticseg(imdsTest,net, ...
    'MiniBatchSize',4, ...
    'WriteLocation',tempdir, ...
    'Verbose',false);

metrics = evaluateSemanticSegmentation(pxdsResults,pxdsTest,'Verbose',false);
metrics.DataSetMetrics
metrics.ClassMetrics

cm = confusionchart(metrics.ConfusionMatrix.Variables, classes);
cm.Title = 'Normalized Confusion Matrix (%)';

imageIoU = metrics.ImageMetrics.MeanIoU;
figure
histogram(imageIoU)
title('Image Mean IoU')
