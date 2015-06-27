
                             
vidDevice = VideoReader('3.mp4');
vid=vision.VideoFileReader('3.mp4');


%region of interest
objectFrame = step(vid);

figure; imshow(objectFrame); objectRegion=round(getPosition(imrect));


objectRegion


%%
% Create VideoPlayer System objects to display the videos.
hVideoIn = vision.VideoPlayer;
hVideoIn.Name  = 'Original Video';
hVideoOut = vision.VideoPlayer;
hVideoOut.Name  = 'Motion Detected Video';


writerObj = VideoWriter('optflow.avi');
writerObj.FrameRate = 30;
writerObj.Quality = 100;
open(writerObj);

writerObj2 = VideoWriter('original.avi');
writerObj2.FrameRate = 30;
writerObj2.Quality = 100;
open(writerObj2);

% Set up for stream
nFrames = 0;
MAG=[] ;
T=[];

 points1 = imcrop(step(vid),objectRegion);
 
  
while (nFrames<500)  
   
    points2 = imcrop(step(vid),objectRegion);
 
 
  
    %optFlow = step(optical,points);
    resultVector=estimate_flow_interface(points1, points2,'classic+nl-fast');
    
    
    d=size(resultVector);
    T=[T nFrames];
    optflowMAG=sqrt(resultVector(:,:,1).^2+resultVector(:,:,2).^2);
    
    MAG = [MAG sum(sum(optflowMAG))/(d(1)*d(2))];
    
    MAG(1)=0;
    
   if(length(MAG)>100)
       plot(T(end-100:end), MAG(end-100:end));
    else
       plot(T,MAG);
    end
   
   

    % Send image data to video player
    % Display original video.
     step(hVideoIn, points2);
     
   %normalize optflow (take values between 0 and 1)
   optNormalize= optflowMAG/max(optflowMAG(:));
   
   %save as images
   %s=strcat(num2str(nFrames),'.png');
   %imwrite(optNormalize,s); 
   
   
   %write image file and preview the optflow
    writeVideo(writerObj,optNormalize);
    writeVideo(writerObj2,points2);

    % Send image data to video player
    % Display original video.
     step(hVideoOut, optNormalize);
    
    % Increment frame count
    nFrames = nFrames + 1;
    
    points1=points2;
    
end


close(writerObj);
close(writerObj2);

release(vidDevice);
release(vid);
release(hVideoIn);
release(hVideoOut);


