function labelIDs = chilliPixelLabelIDs()

labelIDs= { ...
        %FLAT
         [
         128 128 128; ... %Path-Gray
         ]
         
         %LIVINGTHINGS
         [255 165 000; ... %Person-Orange
          255 255 000; ... %Animal-Yellow
         ]
         
         %PLANTATION     
         [128 000 128; ... %Polybag-Purple
          128 128 000; ...%SupportPole-Olive
          000 255 000; ...%Irrigation-Lime
          210 105 030; ...%Rope-Chocolate
          255 020 147; ...%StickyStrap-Deep Pink
         ]
         
         %VEGETATION
         [
         144 238 144; ... %Plant-Light Green
         ]
         
         %MISCELLANEOUSOBJECT]
         [255 218 185; ... %Dynamic-Peach Puff
         245 245 220; ... %Static-Beige
         ] 
         %CONSTRUCTION]
         [199 21 133; ... %Fence-medium violet red
         186 85 211; ... %House-medium orchid
         255 0 0; ... %Arch-red
         184 134 11; ...%FencePole-dark golden rod[CONSTRUCTION]
         189 183 107; ... %Gate-dark khaki[CONSTRUCTION]
         65 105 225; ... %Pole-royal blue[CONSTRUCTION]
         255 0 255; ... %Wall-magenta / fuchsia[CONSTRUCTION]
         ]
         
         %NATURE
         [34 139 34; ... %Tree-forest green[NATURE]
         124 252 0; ... %Bushes-lawn green[NATURE]
         ]
         
         %[VEHICLE]
         [
         188 143 143; ... %Car-rosy brown
         147 112 219; ... %Backhoe-medium purple[VEHICLE]
         220 20 60; ... %Motorcycle-crimson[VEHICLE]
         ]
         
         %[SKY]
         [
         135 206 250; ...%Sky-light sky blue
         ] 
         
         };
end