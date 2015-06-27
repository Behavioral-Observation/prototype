
                             
vidDevice = VideoReader('3.mp4');
vid=vision.VideoFileReader('3.mp4');



% 277   235    79    94

%[160,193,558,288]

writerObj = VideoWriter('imagesub.avi');
writerObj.FrameRate = 30;
vidObj.Quality = 100;
open(writerObj);


%%
% Create VideoPlayer System objects to display the videos.
hVideoIn = vision.VideoPlayer;
hVideoIn.Name  = 'Original Video';
hVideoOut = vision.VideoPlayer;
hVideoOut.Name  = 'Motion Detected Video';

%% Stream Acquisition and Processing Loop
% Create a processing loop to perform motion detection in the input
% video. This loop uses the System objects you instantiated above.

% Set up for stream
nFrames = 1;
rgbData1 = imcrop(rgb2gray(step(vid)),[277 235 79 94]);
MAG=[];
T=[];
while (nFrames<500)     % Process for the first 100 frames.
    % Acquire single frame from imaging device.
    
     rgbData2 = imcrop(rgb2gray(step(vid)),[277 235 79 94]);
    % Compute the optical flow for that particular frame.
   % optFlow = step(optical,rgb2gray(rgbData));
   optFlow=imabsdiff(rgbData2,rgbData1);
   val=sum(sum(optFlow))/( 79*94);
   T=[T nFrames];
   if(val<0.000000001)
    MAG=[MAG 0];
   else
    MAG=[MAG val];
   end
    
    MAG(1)=0;
    if(length(MAG)>100)
       plot(T(end-100:end), MAG(end-100:end));
    else
       plot(T,MAG);
    end
   
     %normalize optflow (take values between 0 and 1)
     range=max(optFlow(:))-min(optFlow(:));

     optNormalize= (optFlow-min(optFlow(:)))/range;
    
    %write image file and preview the optflow
    writeVideo(writerObj,optNormalize);
    step(hVideoIn, rgbData2);
    step(hVideoOut, optNormalize);
 

    % Increment frame count
   
    nFrames = nFrames + 1;
    rgbData1=rgbData2;
end



%% Release
% Here you call the release method on the System objects to close any open 
% files and devices.

close(writerObj);

release(vidDevice);
release(vid);
release(hVideoIn);
release(hVideoOut);



