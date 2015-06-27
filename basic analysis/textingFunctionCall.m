function [ x ] = textingFunctionCall( vid,hAxes,vidDevice,treshold )



%region of interest
objectFrame = step(vid);

axes(hAxes.axis1);
imshow(objectFrame); objectRegion=round(getPosition(imrect));
imshow(objectFrame); title('Yellow box shows object region');

cla(hAxes.axis1);

x=[1 2 3];
y=x;


% Set up for stream
nFrames = 0;
MAG=[] ;
T=[];

 points1 = imcrop(step(vid),objectRegion);

i=0;
while (nFrames<500)  
   
    points2 = imcrop(step(vid),objectRegion);
 
 
  
    %optFlow = step(optical,points);
    resultVector=estimate_flow_interface(points1, points2,'classic+nl-fast');
    
    
    d=size(resultVector);
    T=[T nFrames];
    optflowMAG=sqrt(resultVector(:,:,1).^2+resultVector(:,:,2).^2);
    
    MAG = [MAG sum(sum(optflowMAG))/(d(1)*d(2))];
    
    MAG(1)=0;
    axes(hAxes.axis2);
    % plot(mdnflter(double(MAG)));
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
       
     value= MAG(end-100:end);
     plot(time(end-300:end),SMAG(end-300:end));
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
   

    % Send image data to video player
    % Display original video.
    %step(hVideoIn, points2);
    
    showFrameOnAxis(hAxes.axis1, points2);

     
   %normalize optflow (take values between 0 and 1)
   optNormalize= optflowMAG/max(optflowMAG(:));
   
   %save as images
   %s=strcat(num2str(nFrames),'.png');
   %imwrite(optNormalize,s); 
   
   
   %write image file and preview the optflow


    % Send image data to video player
    % Display original video.
    % step(hVideoOut, optNormalize);
    
    % Increment frame count
    nFrames = nFrames + 1;
    
    points1=points2;
    
end



end

