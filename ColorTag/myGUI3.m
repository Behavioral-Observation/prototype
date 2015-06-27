function myGUI3()

%[FileName,PathName] = uigetfile('*.*','Select the MATLAB code file');

%videoSrc = vision.VideoFileReader('ChristinaPerri.mp4', 'ImageColorSpace', 'Intensity');
global popup;
global val;

global threshold;
global thresholdValue;

val=1;
thresholdValue='0.001';
[hFig, hAxes] = createFigureAndAxes();

%insertButtons(hFig, hAxes, videoSrc);

insertLoadButton(hFig, hAxes);

%playCallback(findobj('tag','PBButton123'),[],videoSrc,hAxes);


function [hFig, hAxes] = createFigureAndAxes()

        % Close figure opened by last run
        figTag = 'CVST_VideoOnAxis_9804532';
        close(findobj('tag',figTag));

        % Create new figure
        hFig = figure('numbertitle', 'off', ...
               'name', 'Behavioral Observation', ...
               'menubar','none', ...
               'toolbar','none', ...
               'resize', 'on', ...
               'tag',figTag, ...
               'renderer','painters', ...
               'position',[15 50 1340 680]);

        % Create axes and titles
        hAxes.axis1 = createPanelAxisTitle(hFig,[0.1 0.50 0.4 0.4],'Video'); % [X Y W H]
        hAxes.axis2 = createPanelAxisTitle(hFig,[0.55 0.50 0.4 0.4],'Color Filter');
        hAxes.axis3 = createPanelAxisTitle(hFig,[0.1 0.05 0.4 0.4],'Magnitude Spectrum');
        hAxes.axis4 = createPanelAxisTitle(hFig,[0.55 0.05 0.4 0.4],'Peak Spectrum');
end

    function hAxis = createPanelAxisTitle(hFig, pos, axisTitle)

        titlePos = [pos(1)+0.02 pos(2)+pos(3)-0.04 0.3 0.08];
        
        
        
        uicontrol('style','text',...
            'String', axisTitle,...
            'Units','Normalized',...
            'fontsize',10,...
            'Parent',hFig,'Position', titlePos,...
            'BackgroundColor',hFig.Color);
        
        % Create panel
        hPanel = uipanel('parent',hFig,'Position',pos,'Units','Normalized');

        % Create axis
        
        
        hAxis = axes('position',[.1 .1 0.8 0.8],'Parent',hPanel);
        
        if strcmp(axisTitle,'Video') || strcmp(axisTitle,'Color Filter')
            hAxis = axes('position',[0 0 1 1],'Parent',hPanel);
        end
        hAxis.XTick = [];
        hAxis.YTick = [];
        hAxis.XColor = [1 1 1];
        hAxis.YColor = [1 1 1];
        % Set video title using uicontrol. uicontrol is used so that text
        % can be positioned in the context of the figure, not the axis.
        
        
        
    end

    function insertButtons(hFig,hAxes,vid,vidDevice,fullPath)
        
        % popup = uicontrol('Style', 'popup',...
         %  'String', {'VisionToolBox','OpticalFloor','ImageSubtraction','ColorTag'},...
          % 'Position', [135 620 200 50]);  
       
       %popup.Value=val;
       
       threshold = uicontrol(hFig,'unit','pixel','style','edit','string',thresholdValue,...
                'HorizontalAlignment','left',...
                'position',[740 650 50 25]);
            
        threshold.String=thresholdValue;    
            
        
        
        % Load File button with text Exit
        uicontrol(hFig,'unit','pixel','style','pushbutton','string','Load and Start',...
                'position',[200 10 100 25],'callback', ...
                {@LoadCallback,vid,hAxes});
            
        uicontrol(hFig,'unit','pixel','style','pushbutton','string','Exit',...
                'position',[135 10 50 25],'callback', ...
                {@exitCallback,vid,hFig});
        
        % Load File button with text Exit
        uicontrol(hFig,'unit','pixel','style','edit','string','path',...
                'HorizontalAlignment','left',...
                'position',[335 10 280 25]);
            
       
    end

function playCallback(hObject,~,vid,hAxes,vidDevice,fullPath)
    
    
    
    uicontrol(hFig,'unit','pixel','style','edit','string',fullPath,...
                'HorizontalAlignment','left',...
                'position',[335 10 280 25]);
    
    c=val;
    
    
    colorflter(vid,hAxes,vidDevice,str2double(thresholdValue));
    
end

function [frame,rotatedImg,angle] = getAndProcessFrame(videoSrc,angle)

        % Read input video frame
        frame = step(videoSrc);

        % Pad and rotate input video frame
        paddedFrame = padarray(frame, [30 30], 0, 'both');
        rotatedImg  = imrotate(paddedFrame, angle, 'bilinear', 'crop');
        angle       = angle + 1;
end
function exitCallback(~,~,videoSrc,hFig)

        % Close the video file
        release(videoSrc);
        % Close the figure window
        close(hFig);
        quit cancel;
end


%%%%%%%%%%%%%%%%%%
function LoadCallback(hObject,~,videoSrc,hAxes)
    
    %val=get(popup, 'Value');
    thresholdValue=get(threshold, 'String');
    
    [FileName,PathName] = uigetfile('*.*','Select the MATLAB code file');
    fullPath=strcat(PathName,FileName);
    videoSrc = vision.VideoFileReader(strcat(PathName,FileName), 'ImageColorSpace', 'RGB');

    [hFig, hAxes] = createFigureAndAxes();
    
    vidDevice = VideoReader(strcat(PathName,FileName));
    vid=vision.VideoFileReader(strcat(PathName,FileName));

    insertButtons(hFig, hAxes, vid, vidDevice,fullPath);
    
    


   
    %% 
    % Create a System object to estimate direction and speed of object motion
    % from one video frame to another using optical flow.

 
    
    
    

    playCallback(findobj('tag','PBButton123'),[],vid,hAxes,vidDevice,fullPath);
     
end

%%%%%%%%%%%%%%

function insertLoadButton(hFig,hAxes)

        
            
       % popup = uicontrol('Style', 'popup',...
        %   'String', {'VisionToolBox','OpticalFloor','ImageSubtraction','ColorTag'},...
         %  'Position', [135 620 200 50]);   
       
        
        threshold = uicontrol(hFig,'unit','pixel','style','edit','string','0.001',...
                'HorizontalAlignment','left',...
                'position',[740 650 50 25]);
        %selectedAlorithm=get(popup, 'Value');
        % Load File button with text Exit
        uicontrol(hFig,'unit','pixel','style','pushbutton','string','Load and Start',...
                'position',[135 10 100 25],'callback', ...
                {@LoadCallback,hAxes});
            
       
    end

%%%%%%%%%%%%%

end