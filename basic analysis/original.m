
                             
vidDevice = VideoReader('3.mp4');
vid=vision.VideoFileReader('3.mp4');
%% 
% Create a System object to estimate direction and speed of object motion
% from one video frame to another using optical flow.
optical = vision.OpticalFlow( ...
    'OutputValue', 'Magnitude-squared', 'Method','Lucas-Kanade');

%% 
% Initialize the vector field lines.
maxWidth = vidDevice.Width;
maxHeight = vidDevice.Height;





%%
% Create VideoPlayer System objects to display the videos.
hVideoIn = vision.VideoPlayer;
hVideoIn.Name  = 'Original Video';


%% Stream Acquisition and Processing Loop
% Create a processing loop to perform motion detection in the input
% video. This loop uses the System objects you instantiated above.

% Set up for stream

nFrames = 1;

MAG=[];
T=[];
i=0;
while (nFrames<1000000)     % Process for the first 100 frames.
    % Acquire single frame from imaging device.
    
    rgbData=step(vid);
    %rgbData=tfilter(step(vid),[110,60,30;190,150,120]);
    
    % Compute the optical flow for that particular frame.
    optFlow = step(optical,rgb2gray(rgbData));
    
    val=sum(sum(optFlow))/(maxWidth*maxHeight);
    % T=[T nFrames];
    if(val<0.001)
        MAG=[MAG 0];
    else
        MAG=[MAG val];
    end
    
    MAG(1)=0;
    
    %fMAG= mdnflter(double(MAG));
    if(length(MAG)>i+30)
    [pks,locs] = findpeaks(mdnflter(double(MAG)));

    rate=30;
    i=0;
    fMAG=[];
    while i< locs(length(locs))
    % while i<= length(T)
        fMAG=[fMAG length(locs(locs>=i & locs<=i+rate))];
        i=i+rate;

    end
    T=[T i/rate];
    
    if(length(fMAG)>100)
       plot(T(end-100:end), fMAG(end-100:end));
    else
       plot(T(1:length(fMAG)),fMAG);
    end
    end
    % Send image data to video player
    % Display original video.
    step(hVideoIn, rgbData);
 

    % Increment frame count
   
    nFrames = nFrames + 1;
end



%% Release
% Here you call the release method on the System objects to close any open 
% files and devices.





