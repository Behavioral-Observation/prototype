function [ x ] = visionToolBox( vid,hAxes,vidDevice,treshold )

optical2 = vision.OpticalFlow( ...
    'OutputValue', 'Magnitude-squared', 'Method','Lucas-Kanade');
optical = vision.OpticalFlow( ... 
    'OutputValue', 'Horizontal and vertical components in complex form', 'Method','Lucas-Kanade');


objectFrame = step(vid);

axes(hAxes.axis1);
imshow(objectFrame); objectRegion=round(getPosition(imrect));

%imshow(imcrop(objectFrame,objectRegion));



%% 
% Initialize the vector field lines.
%maxWidth = vidDevice.Width;
maxWidth = objectRegion(3);
maxHeight = objectRegion(4);
%maxHeight = vidDevice.Height;

% Initialize the vector field lines.
shapes = vision.ShapeInserter;
shapes.Shape = 'Lines';
shapes.BorderColor = 'white';
r = 1:1:maxHeight;
c = 1:1:maxWidth;
[Y, X] = meshgrid(c,r);








%% Stream Acquisition and Processing Loop
% Create a processing loop to perform motion detection in the input
% video. This loop uses the System objects you instantiated above.

% Set up for stream
nFrames = 1;

MAG=[];
T=[];
%treshold=0.001;
i=0;

cla(hAxes.axis1);

while (nFrames<3000)     % Process for the first 100 frames.
    % Acquire single frame from imaging device.
   % rgbData=tfilter(step(vid),[110,60,30;190,150,120]);
    rgbData=imcrop(step(vid),objectRegion);
    
    showFrameOnAxis(hAxes.axis1, rgbData);
    % Compute the optical flow for that particular frame.
    optFlow = step(optical,rgb2gray(rgbData));
    optFlowMAG = step(optical2,rgb2gray(rgbData));
    % Downsample optical flow field.
    optFlow_DS = optFlow(r, c);
    H = imag(optFlow_DS)*2;
    V = real(optFlow_DS)*2;
    
    % Draw lines on top of image
    lines = [Y(:)'; X(:)'; Y(:)'+V(:)'; X(:)'+H(:)'];
    rgb_Out = step(shapes, rgbData,  lines');
  
   val=sum(sum(optFlowMAG))/(maxWidth*maxHeight);
   T=[T nFrames];
   if(val<treshold)
    MAG=[MAG 0];
   else
    MAG=[MAG val];
   end
    
    MAG(1)=0;
   % plot(mdnflter(double(MAG)));
   
   axes(hAxes.axis2);
    SMAG=mdnflter(double(MAG));
    time=0:1/30:length(SMAG)/30;
   if(length(SMAG)<=300)
       if(length(SMAG)<30)
         plot(SMAG);
       else
           
            plot(time(2:end),SMAG);
       end
       value=MAG;
   else
       
     plot(time(end-300:end),SMAG(end-300:end));
     value= MAG(end-100:end);
   end
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   axes(hAxes.axis3);
   
   if(length(SMAG)>i+30)
       [fMAG,i]=numberofpeaks(SMAG,30);
   
    if(length(fMAG)>100)
        plot(time(end-300:end), fMAG(end-100:end));
    else
        plot(T(1:length(fMAG)),fMAG);
    end
   end
    
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   axes(hAxes.axis4);
   dftvalue = fft(value);
     freq = -pi:(2*pi)/length(value):pi-(2*pi)/length(value);
     magnitude=abs(fftshift(dftvalue));
	 magnitude(1)=0;
     
     
     phase=angle(fftshift(dftvalue));
     plot(freq,magnitude);
   
    
    %normalize optflow (take values between 0 and 1)
   % optNormalize= optFlow/max(optFlow(:));
    
    %write image file and preview the optflow
   % writeVideo(writerObj,optNormalize);
  
    % Increment frame count
   
    nFrames = nFrames + 1;
end


end
%% Releas

