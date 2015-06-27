function [ x ] = imageSubstarction( vid,hAxes,vidDevice,treshold )
                             


%% Stream Acquisition and Processing Loop
% Create a processing loop to perform motion detection in the input
% video. This loop uses the System objects you instantiated above.

% Set up for stream
nFrames = 1;

objectFrame = step(vid);

axes(hAxes.axis1);
imshow(objectFrame); objectRegion=round(getPosition(imrect));

rgbData1 = imcrop(rgb2gray(step(vid)),objectRegion);
MAG=[];
T=[];
%treshold=0.001;
i=0;

cla(hAxes.axis1);
while (nFrames<3000)     % Process for the first 100 frames.
    % Acquire single frame from imaging device.
    
    ngrgbData2 = imcrop(step(vid),objectRegion);
    rgbData2 = rgb2gray(ngrgbData2);
    
    
    showFrameOnAxis(hAxes.axis1, ngrgbData2);
    % Compute the optical flow for that particular frame.
   % optFlow = step(optical,rgb2gray(rgbData));
   optFlow=imabsdiff(rgbData2,rgbData1);
   val=sum(sum(optFlow))/( 79*94);
   T=[T nFrames];
   if(val<treshold)
    MAG=[MAG 0];
   else
    MAG=[MAG val];
   end
    
    MAG(1)=0;
    axes(hAxes.axis2);
     SMAG=mdnflter(double(MAG));
    time=0:1/30:length(SMAG)/30;
    
%     if(length(MAG)>100)
%        plot(T(end-100:end), MAG(end-100:end));
%     else
%        plot(T,MAG);
%     end


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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
axes(hAxes.axis3);
if(length(SMAG)>i+30)
       [fMAG,i]=numberofpeaks(SMAG,30);
   
    if(length(fMAG)>100)
       plot(time(end-300:end), fMAG(end-100:end));
    else
       plot(T(1:length(fMAG)),fMAG);
    end
   end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 axes(hAxes.axis4);
  dftvalue = fft(value);
     freq = -pi:(2*pi)/length(value):pi-(2*pi)/length(value);
     magnitude=abs(fftshift(dftvalue));
	 magnitude(1)=0;
     
     
     phase=angle(fftshift(dftvalue));
     plot(freq,magnitude);
 
 
 
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %normalize optflow (take values between 0 and 1)
     range=max(optFlow(:))-min(optFlow(:));

     optNormalize= (optFlow-min(optFlow(:)))/range;
    
    %write image file and preview the optflow


    % Increment frame count
   
    nFrames = nFrames + 1;
    rgbData1=rgbData2;
    
end


end
%% Release
% Here you call the release method on the System objects to close any open 



