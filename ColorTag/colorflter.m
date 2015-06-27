function [x]=colorflter(vid,hAxes,vidDevice,treshold)

%name='athal.avi';                           
%vidDevice = VideoReader(name);
%vid=vision.VideoFileReader(name);
%% 
% Create a System object to estimate direction and speed of object motion
% from one video frame to another using optical flow.
optical2 = vision.OpticalFlow( ...
    'OutputValue', 'Magnitude-squared', 'Method','Lucas-Kanade');
optical = vision.OpticalFlow( ... 
    'OutputValue', 'Horizontal and vertical components in complex form', 'Method','Lucas-Kanade');




%imshow(imcrop(objectFrame,objectRegion));








%%

%% Stream Acquisition and Processing Loop
% Create a processing loop to perform motion detection in the input
% video. This loop uses the System objects you instantiated above.


% objectFrame = step(vid);
% 
% figure; imshow(objectFrame); objectRegion=round(getPosition(imrect));



% Set up for stream
nFrames = 1;

MAG=[];
T=[];
i=0;
while (nFrames<5000)     % Process for the first 100 frames.
    % Acquire single frame from imaging device.
   % rgbData=tfilter(step(vid),[110,60,30;190,150,120]); [0.6196 0.549 0.02745 ; 0.7647 0.6784 0.06667]
   ff=step(vid);
   f=imresize(ff,[400 400]);
   showFrameOnAxis(hAxes.axis1, f);
   
   rgbData=tfilter(f,[0.5 0.4 0.0015 ; 0.98 0.9 0.35]);
    showFrameOnAxis(hAxes.axis2, rgbData);
     % rgbData=  imcrop(step(vid),objectRegion);
    % Compute the optical flow for that particular frame.
    optFlow = step(optical,rgb2gray(rgbData));
    optFlowMAG = step(optical2,rgb2gray(rgbData));
  
    
    [h,w]=size(optFlowMAG);
  
   val=sum(sum(optFlowMAG))/(h*w);

   T=[T nFrames];
   
    MAG=[MAG val];
   
   
    value = [];
    
    MAG(1)=0;
   % if(length(MAG)>100)
    %   plot(T(end-100:end), MAG(end-100:end));
     %  value= MAG(end-100:end);
    %else
    axes(hAxes.axis3);
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
       
      plot(time(1:length(SMAG)),SMAG);
     value= MAG(end-100:end);
   end
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   axes(hAxes.axis4);
   
   if(length(SMAG)>i+30)
       [fMAG,i]=numberofpeaks(SMAG,30);
   
       plot(1:length(fMAG), fMAG);
    
   end
    
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   dftvalue = fft(value);
     freq = -pi:(2*pi)/length(value):pi-(2*pi)/length(value);
     magnitude=abs(fftshift(dftvalue));
	 magnitude(1)=0;
     
     
     phase=angle(fftshift(dftvalue));
    % plot(freq,magnitude);
     % or stem(freq,unwrap(angle(dftvalue)),'markerfacecolor',[0 0 1])  
    
    
    %normalize optflow (take values between 0 and 1)

   
    nFrames = nFrames + 1;
end


end

