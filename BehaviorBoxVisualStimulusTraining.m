classdef BehaviorBoxVisualStimulusTraining
    %Display training stimulus 
    
    %====================================================================
    %This Class is called by the class BehaviorBoxSuper and creates a
    %single stimulus for training purposes. The stimulus is made up of
    %aligned lined segments with no background.
    
    %It can creates 4 different stimuli (contour, contour training, patch
    %and square) depending on what is being trained and is set by what is
    %passed into the constructor.
    
    %It creates a line or shape of line of aligned elements (adapted from
    %Wu Li/T Van Kerkoerle). 
    %The parameters (size, contrast, coarseness etc are obtained from the
    %GUI via BehaviorBoxSub1 and passed in here via DisplayOnScreen(), which
    %also shows the stimulus on screen. 
    
    
    %Meyer 2015/5
    
    %THIS FILE IS PART OF A SET OF FILES CONTAINING (ALL NEEDED):
    %BehaviorBox.fig
    %BehaviorBox.m
    %BehaviorBoxData.m
    %BehaviorBoxSub1.m
    %BehaviorBoxSub2.m
    %BehaviorBoxSuper.m
    %BehaviorBoxVisualGratingObject.m
    %BehaviorBoxVisualStimulus.m
    %BehaviorBoxVisualStimulusTraining.m
    %====================================================================
    
    
    
    
   
    properties(GetAccess = 'private', SetAccess = 'private')
        
        l=7; %width of each lines %defaul 19
        segments=9; %number of segments of contoru 5
        dx=1;% this is the inital starting offset for the first line in each colum
        dy=4; %and each rows. Every other column gets shifted to form interleaved pattern
        cy=5;  %y start position of contour, from bottom
        cx=4;%x start position of countour, from right edge
        transparenttrigger=1; % if this is 1, make bar transpartent
        linesy=11; %how many lines in y 7
        linesx=17;%how many lines in x 11
        zoomfactor = 1;
        
    end
    
    
    
    properties(SetAccess = 'public', GetAccess = 'private')
       
        trialID;
        show;
        opacity;
        StimulusType;
        Levertype;
    end
    
    
    
    
    methods
        
         %constructor
        function this = BehaviorBoxVisualStimulusTraining(StimulusType, trialID, opacity, Levertype)
            
            if(nargin > 0)
                %left of right
                this.trialID = trialID;
                %background opacity
                this.opacity    = opacity;
                this.StimulusType =StimulusType;
                this.Levertype = Levertype;
            end
            
            
        end
        
        
        %interface
        function DisplayOnScreen(this, display, winheight,winwidth,winx, winy, orientation)
            
            %fill window size parameters if not supplied
             switch nargin
                case 2
                    winheight = 300;
                    winwidth = 1000;
                    winx = 400;
                    winy = 300;
                    orientation = 85;
                    
                case 3
                    winwidth = 1000;
                    winx = 400;
                    winy = 300;
                    orientation = 85;
                case 4
                    winx = 400;
                    winy = 300;
                    orientation = 85;
                case 5
                    winy = 300;
                    orientation = 85;
                case 6
                    orientation = 85;
            end
            
            if this.StimulusType==1
                if this.Levertype==1
                    ShowStimulusOnePatch(this, this.trialID, this.opacity, display,winheight,winwidth,winx,winy,0,orientation)
                else
                    ShowStimulusContour(this.trialID, this.opacity,display,winheight,winwidth,winx,winy, 0,orientation);
                end
            elseif this.StimulusType==2
                if this.Levertype==1
                    ShowStimulusOnePatch(this, this.trialID, this.opacity, display,winheight,winwidth,winx,winy,1,orientation)
                else
                    ShowStimulusContour(this.trialID, this.opacity,display,winheight,winwidth,winx,winy, 1,orientation);
                end
            elseif this.StimulusType==3
                
                ShowStimulusSquare(this.trialID, this.opacity,display,winheight,winwidth,winx,winy, 0,orientation);
                
            elseif this.StimulusType==4
                ShowStimulusSquare(this.trialID, this.opacity,display,winheight,winwidth,winx,winy, 1,orientation);
                
            elseif this.StimulusType==5
                
                ShowStimulusContourTraining(this.trialID,0,display,winheight,winwidth,winx,winy,0,orientation);
              
                 elseif this.StimulusType==5
                
                ShowStimulusContourDistractor(this.trialID,0,display,winheight,winwidth,winx,winy,0,orientation);
          
            
            
            
            
            end
            
            
        end
        
    end
    
end


%display square stimulus
function ShowStimulusSquare(trialID, opacity, display, winheight,winwidth,winx,winy,crudetoggle,Orient)


fig1=figure(100);
%show yes or no
if display==1
    
    if crudetoggle==0
        %fine
        
        ContLength=3; % length of contour
        ContLengthHalf=ceil(ContLength/2); %half of the contour
        PatchSize=11; % size of patch, pick uneven
        PatchSizeHalf=floor(PatchSize/2); %half of the patch
        SegmLength=1.2; %length of sements
        BinSize=2; %size of bins
        SegmThick=7; %line thickness9
        SegmJitter= 0.3;% jitter of segments
        
    else
        %crude
        
        ContLength=3; % length of contour
        ContLengthHalf=ceil(ContLength/2); %half of the contour
        PatchSize=9; % size of patch, pick uneven
        PatchSizeHalf=floor(PatchSize/2); %half of the patch
        SegmLength=1.2; %length of sements
        BinSize=2; %size of bins
        SegmThick=9; %line thickness9
        SegmJitter= 0.3;% jitter of segments
        
    end
    
    
    Alpha=-25; %determines closeness of contour elements, set somewhere between [-30 30]
    %see Li & Gilbert 2002
    Alpha=(90+Alpha)/90;
    
    SegmX=zeros(2,PatchSize,PatchSize);
    SegmY=zeros(2,PatchSize,PatchSize);
    % make grid
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=i*BinSize;
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=j*BinSize;
        end
    end
    
    % turn grid around crossing with y-axis
    [SegmTheta,SegmRho] = cart2pol(zeros(2,PatchSize,PatchSize),SegmY);
    SegmTheta(SegmTheta>0)=SegmTheta(SegmTheta>0)/Alpha;
    SegmTheta(SegmTheta<0)=((SegmTheta(SegmTheta<0)+pi)/Alpha)-pi;
    [SegmXA,SegmY] = pol2cart(SegmTheta,SegmRho);
    SegmX=SegmX+SegmXA;
    
    % Draw background with the grid as center
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            angle=rand*180;
            
            if i==j  & i>-ContLengthHalf &i<ContLengthHalf %for contour segments (take center colum and then go along that)
                angle=45;
                X=[-SegmLength*0.1 SegmLength*0.9];
                Y=[0 0];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
                
                
            elseif i==j-1  & i>-ContLengthHalf &i<ContLengthHalf %for contour segments (take center colum and then go along that)
                angle=45;
                X=[-SegmLength*0.85 SegmLength*0.15];
                Y=[0 0];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
                
                
                
            elseif i==j+1  & i>-ContLengthHalf+1 &i<ContLengthHalf+1 %for contour segments (take center colum and then go along that)
                angle=45;
                % X=[-(SegmLength*0.4)+SegmLength (SegmLength*0.6)+SegmLength];
                X=[-(SegmLength*0.8) (SegmLength*0.2)];
                Y=[0 0];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
                
            else
                JX=SegmJitter*2*(rand-0.5); %introduce jitter on non contour segments only
                JY=SegmJitter*2*(rand-0.5);
                X=[-SegmLength/2 SegmLength/2]+JX;
                Y=[0 0]-JY;
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi;
                [X,Y] = pol2cart(Theta,Rho);
                
            end
            
            
            
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+X';
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+Y';
        end
    end
    
    
    %plot all line segments
    
    
    
    if trialID==1
        figu=subplot(1,2,2);
    else
        subplot(1,2,1);
    end
    
    
    set(gca,'color','black')
    set(gcf,'color','black')
    
    hold on;
    
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick,'Color',[1*opacity 1*opacity 1*opacity])
        end
    end
    
    hold on
    
    % Draw segments grid as center
    
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            
            
            
            if i==j  & i>-ContLengthHalf &i<ContLengthHalf & i~=ContLengthHalf %for contour segments (take center colum and then go along that)
                
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick)
                
                
            elseif i==j-1  & i>-ContLengthHalf &i<ContLengthHalf %for contour segments (take center colum and then go along that)
                
                
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick)
                
                
            elseif i==j+1  & i>-ContLengthHalf+1 &i<ContLengthHalf+1 %for contour segments (take center colum and then go along that)
                
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick)
                
                
            end
            
            
        end
        
    end
    
    
    
    hold off
    
    
    
    %plot mask, upper and lower part separate
    NumPoints=100;
    Radius=(PatchSizeHalf-2)*BinSize;
    Theta=linspace(0,pi,NumPoints); %100 evenly spaced points between 0 and pi
    Rho=ones(1,NumPoints)*Radius; %Radius should be 1 for all 100 points
    [X,Y] = pol2cart(Theta,Rho);
    X(101)=-PatchSize*2;
    Y(101)=0;
    X(102)=-PatchSize*2;
    Y(102)=PatchSize*2;
    X(103)=PatchSize*2;
    Y(103)=PatchSize*2;
    X(104)=PatchSize*2;
    Y(104)=0;
    patch(X,Y,'k');
    Theta=linspace(0,-pi,NumPoints); %100 evenly spaced points between 0 and -pi
    [X,Y] = pol2cart(Theta,Rho);
    X(101)=-PatchSize*2;
    Y(101)=0;
    X(102)=-PatchSize*2;
    Y(102)=-PatchSize*2;
    X(103)=PatchSize*2;
    Y(103)=-PatchSize*2;
    X(104)=PatchSize*2;
    Y(104)=0;
    patch(X,Y,'k');
    
    axis tight; axis square
   
    view(-Orient/Alpha,90)
    
    xlim([-Radius*0.8 Radius*0.8])
    ylim([-Radius*0.8 Radius*0.8])
    
    % print -dbmp LiStim1
    
    
    % SECOND PART OF FOGURE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    hold on
    % make grid
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=i*BinSize;
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=j*BinSize;
        end
    end
    
    % turn grid around crossing with y-axis
    [SegmTheta,SegmRho] = cart2pol(zeros(2,PatchSize,PatchSize),SegmY);
    SegmTheta(SegmTheta>0)=SegmTheta(SegmTheta>0)/Alpha;
    SegmTheta(SegmTheta<0)=((SegmTheta(SegmTheta<0)+pi)/Alpha)-pi;
    [SegmXA,SegmY] = pol2cart(SegmTheta,SegmRho);
    SegmX=SegmX+SegmXA;
    
    % Draw background with the grid as center
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            angle=rand*180;
            
            if i==j  & i>-ContLengthHalf &i<ContLengthHalf & i  %for contour segments (take center colum and then go along that)
                angle=45;
                X=[-SegmLength*0.1 SegmLength*0.9];
                Y=[0 0];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
                
                
            elseif  i==j  & i>-ContLengthHalf &i<ContLengthHalf %make sure the center of O is not randomly filling patch (avoid 45)
                
                angle=rand*155+75;
                
                JX=SegmJitter*2*(rand-0.7); %introduce jitter on non contour segments only
                JY=SegmJitter*2*(rand-0.4);
                X=[-SegmLength*0.1 SegmLength*0.9]+JX-0.17;
                Y=[0 0]-JY-0.4;
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi;
                [X,Y] = pol2cart(Theta,Rho);
                
                
                
                
            elseif i==j-1  & i>-ContLengthHalf &i<ContLengthHalf %for contour segments (take center colum and then go along that)
                angle=45;
                X=[-SegmLength*0.85 SegmLength*0.15];
                Y=[0 0];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
                
                
                
            elseif i==j+1  & i>-ContLengthHalf+1 &i<ContLengthHalf+1 %for contour segments (take center colum and then go along that)
                angle=45;
                % X=[-(SegmLength*0.4)+SegmLength (SegmLength*0.6)+SegmLength];
                X=[-(SegmLength*0.8) (SegmLength*0.2)];
                Y=[0 0];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
                
            else
                JX=SegmJitter*2*(rand-0.5); %introduce jitter on non contour segments only
                JY=SegmJitter*2*(rand-0.5);
                X=[-SegmLength/2 SegmLength/2]+JX;
                Y=[0 0]-JY;
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi;
                [X,Y] = pol2cart(Theta,Rho);
                
            end
            
            
            
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+X';
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+Y';
        end
    end
    
    
    %plot all line segments
    
    if trialID==1
        figu=subplot(1,2,1);
    else
        subplot(1,2,2);
    end
    
    
    set(gca,'color','black')
    set(gcf,'color','black')
    
    hold on;
    
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick,'Color',[1*opacity 1*opacity 1*opacity])
        end
    end
    
    hold on
    
    % Draw segments grid as center
    
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            
            
            
            if i==j  & i>-ContLengthHalf &i<ContLengthHalf & i~=ContLengthHalf & i~=0%for contour segments (take center colum and then go along that)
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick)
                
                
            elseif i==j-1  & i>-ContLengthHalf &i<ContLengthHalf %for contour segments (take center colum and then go along that)
                
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick)
                
                
            elseif i==j+1  & i>-ContLengthHalf+1 &i<ContLengthHalf+1 %for contour segments (take center colum and then go along that)
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick)
                
                
            end
            
            
            
        end
        
    end
    
    
    
    hold off
    
    
    
    %plot mask, upper and lower part separate
    NumPoints=100;
    Radius=(PatchSizeHalf-2)*BinSize;
    Theta=linspace(0,pi,NumPoints); %100 evenly spaced points between 0 and pi
    Rho=ones(1,NumPoints)*Radius; %Radius should be 1 for all 100 points
    [X,Y] = pol2cart(Theta,Rho);
    X(101)=-PatchSize*2;
    Y(101)=0;
    X(102)=-PatchSize*2;
    Y(102)=PatchSize*2;
    X(103)=PatchSize*2;
    Y(103)=PatchSize*2;
    X(104)=PatchSize*2;
    Y(104)=0;
    patch(X,Y,'k');
    Theta=linspace(0,-pi,NumPoints); %100 evenly spaced points between 0 and -pi
    [X,Y] = pol2cart(Theta,Rho);
    X(101)=-PatchSize*2;
    Y(101)=0;
    X(102)=-PatchSize*2;
    Y(102)=-PatchSize*2;
    X(103)=PatchSize*2;
    Y(103)=-PatchSize*2;
    X(104)=PatchSize*2;
    Y(104)=0;
    patch(X,Y,'k');
    
    axis tight; axis square
    
  
    view(-Orient/Alpha,90)
    
    xlim([-Radius*0.8 Radius*0.8])
    ylim([-Radius*0.8 Radius*0.8])
    
    pause(0.01);
    
    positionfig=[winx winy winwidth winheight];
    
    set(fig1,'OuterPosition',positionfig) ;%move window here, also determines size
    
else
    
    close(fig1);
    
end

end



%display contour stimulus
function ShowStimulusContour(trialID, opacity, display, winheight,winwidth,winx,winy,crudetoggle,Orient)



fig1=figure(100);
if display==1
    
    
    
    
    if crudetoggle==0
        %fine
        
        ContLength=7; % length of contour
        ContLengthHalf=ceil(ContLength/2); %half of the contour
        PatchSize=9; % size of patch, pick uneven
        PatchSizeHalf=floor(PatchSize/2); %half of the patch
        SegmLength=1.2; %length of sements
        BinSize=2; %size of bins
        SegmThick=7; %line thickness9
        SegmJitter= 0.3;% jitter of segments
        
    else
        %crude
        
        ContLength=7; % length of contour
        ContLengthHalf=ceil(ContLength/2); %half of the contour
        PatchSize=11; % size of patch, pick uneven
        PatchSizeHalf=floor(PatchSize/2); %half of the patch
        SegmLength=1.2; %length of sements
        BinSize=2; %size of bins
        SegmThick=9; %line thickness9
        SegmJitter= 0.3;% jitter of segments
        
    end
    
    
    
    
    
    Alpha=-25; %determines closeness of contour elements, set somewhere between [-30 30]
    %see Li & Gilbert 2002
    Alpha=(90+Alpha)/90;
    
    SegmX=zeros(2,PatchSize,PatchSize);
    SegmY=zeros(2,PatchSize,PatchSize);
    % make grid
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=i*BinSize;
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=j*BinSize;
        end
    end
    
    % turn grid around crossing with y-axis
    [SegmTheta,SegmRho] = cart2pol(zeros(2,PatchSize,PatchSize),SegmY);
    SegmTheta(SegmTheta>0)=SegmTheta(SegmTheta>0)/Alpha;
    SegmTheta(SegmTheta<0)=((SegmTheta(SegmTheta<0)+pi)/Alpha)-pi;
    [SegmXA,SegmY] = pol2cart(SegmTheta,SegmRho);
    SegmX=SegmX+SegmXA;
    
    % Draw background with the grid as center
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            angle=rand*180;
            if i==j & i>-ContLengthHalf &i<ContLengthHalf %for contour segments
                angle=45;
                X=[-SegmLength/2 SegmLength/2];
                Y=[0 0];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
            else
                JX=SegmJitter*2*(rand-0.5); %introduce jitter on non contour segments only
                JY=SegmJitter*2*(rand-0.5);
                X=[-SegmLength/2 SegmLength/2]+JX;
                Y=[0 0]-JY;
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi;
                [X,Y] = pol2cart(Theta,Rho);
            end
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+X';
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+Y';
        end
    end
    
    
    %plot all line segments
    
    
    
    
    if trialID==1
        figu=subplot(1,2,2);
    else
        subplot(1,2,1);
    end
    
    
    set(gca,'color','black')
    set(gcf,'color','black')
    
    hold on;
    
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick,'Color',[1*opacity 1*opacity 1*opacity])
        end
    end
    
    hold on
    
    % Draw segments grid as center
    
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            
            if i==j & i>-ContLengthHalf &i<ContLengthHalf %for contour segments
                angle=45;
                X=[-SegmLength/2 SegmLength/2];
                Y=[0 0];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick)
            end
        end
        
    end
    
    
    
    hold off
    
    
    
    %plot mask, upper and lower part separate
    NumPoints=100;
    Radius=(PatchSizeHalf-2)*BinSize;
    Theta=linspace(0,pi,NumPoints); %100 evenly spaced points between 0 and pi
    Rho=ones(1,NumPoints)*Radius; %Radius should be 1 for all 100 points
    [X,Y] = pol2cart(Theta,Rho);
    X(101)=-PatchSize*2;
    Y(101)=0;
    X(102)=-PatchSize*2;
    Y(102)=PatchSize*2;
    X(103)=PatchSize*2;
    Y(103)=PatchSize*2;
    X(104)=PatchSize*2;
    Y(104)=0;
    patch(X,Y,'k');
    Theta=linspace(0,-pi,NumPoints); %100 evenly spaced points between 0 and -pi
    [X,Y] = pol2cart(Theta,Rho);
    X(101)=-PatchSize*2;
    Y(101)=0;
    X(102)=-PatchSize*2;
    Y(102)=-PatchSize*2;
    X(103)=PatchSize*2;
    Y(103)=-PatchSize*2;
    X(104)=PatchSize*2;
    Y(104)=0;
    patch(X,Y,'k');
    
    axis tight; axis square
   
    view(-Orient/Alpha,90)
    
    xlim([-Radius*0.8 Radius*0.8])
    ylim([-Radius*0.8 Radius*0.8])
    
    % print -dbmp LiStim1
    
    
    % SECOND PART OF FOGURE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    hold on
    % make grid
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=i*BinSize;
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=j*BinSize;
        end
    end
    
    % turn grid around crossing with y-axis
    [SegmTheta,SegmRho] = cart2pol(zeros(2,PatchSize,PatchSize),SegmY);
    SegmTheta(SegmTheta>0)=SegmTheta(SegmTheta>0)/Alpha;
    SegmTheta(SegmTheta<0)=((SegmTheta(SegmTheta<0)+pi)/Alpha)-pi;
    [SegmXA,SegmY] = pol2cart(SegmTheta,SegmRho);
    SegmX=SegmX+SegmXA;
    
    % Draw background with the grid as center
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            angle=rand*180;
            
            JX=SegmJitter*2*(rand-0.5); %introduce jitter on non contour segments only
            JY=SegmJitter*2*(rand-0.5);
            X=[-SegmLength/2 SegmLength/2]+JX;
            Y=[0 0]-JY;
            [Theta,Rho] = cart2pol(X,Y);
            Theta=Theta+angle/180*pi;
            [X,Y] = pol2cart(Theta,Rho);
            
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+X';
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+Y';
        end
    end
    
    
    %plot all line segments
    if trialID==1
        subplot(1,2,1);
    else
        subplot(1,2,2);
    end
    set(gca,'color','black')
    set(gcf,'color','black')
    
    hold on;
    
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick,'Color',[1*opacity 1*opacity 1*opacity])
        end
    end
    
    hold on
    
    
    
    hold off
    
    
    
    
    %plot mask, upper and lower part separate
    NumPoints=100;
    Radius=(PatchSizeHalf-2)*BinSize;
    Theta=linspace(0,pi,NumPoints); %100 evenly spaced points between 0 and pi
    Rho=ones(1,NumPoints)*Radius; %Radius should be 1 for all 100 points
    [X,Y] = pol2cart(Theta,Rho);
    X(101)=-PatchSize*2;
    Y(101)=0;
    X(102)=-PatchSize*2;
    Y(102)=PatchSize*2;
    X(103)=PatchSize*2;
    Y(103)=PatchSize*2;
    X(104)=PatchSize*2;
    Y(104)=0;
    patch(X,Y,'k');
    Theta=linspace(0,-pi,NumPoints); %100 evenly spaced points between 0 and -pi
    [X,Y] = pol2cart(Theta,Rho);
    X(101)=-PatchSize*2;
    Y(101)=0;
    X(102)=-PatchSize*2;
    Y(102)=-PatchSize*2;
    X(103)=PatchSize*2;
    Y(103)=-PatchSize*2;
    X(104)=PatchSize*2;
    Y(104)=0;
    patch(X,Y,'k');
    hold off
    axis tight; axis square
    view(-Orient+45/Alpha,90)
    xlim([-Radius*0.8 Radius*0.8])
    ylim([-Radius*0.8 Radius*0.8])
    set(gcf,'MenuBar','none');
    
    
    positionfig=[winx winy winwidth winheight];
    
    
    %positionfig=[1600 50 500 450];
    set(fig1,'OuterPosition',positionfig) ;%move window here, also determines size
    %notusedyet=borderwidth;
else
    
    close(fig1);
    
end

end



%display contour stimulus
function ShowStimulusContourDistractor(trialID, opacity, display, winheight,winwidth,winx,winy,crudetoggle,Orient)



fig1=figure(100);
if display==1
    
    
    
    
    if crudetoggle==0
        %fine
        
        ContLength=7; % length of contour
        ContLengthHalf=ceil(ContLength/2); %half of the contour
        PatchSize=9; % size of patch, pick uneven
        PatchSizeHalf=floor(PatchSize/2); %half of the patch
        SegmLength=1.2; %length of sements
        BinSize=2; %size of bins
        SegmThick=7; %line thickness9
        SegmJitter= 0.3;% jitter of segments
        
    else
        %crude
        
        ContLength=7; % length of contour
        ContLengthHalf=ceil(ContLength/2); %half of the contour
        PatchSize=11; % size of patch, pick uneven
        PatchSizeHalf=floor(PatchSize/2); %half of the patch
        SegmLength=1.2; %length of sements
        BinSize=2; %size of bins
        SegmThick=9; %line thickness9
        SegmJitter= 0.3;% jitter of segments
        
    end
    
    
    
    
    
    Alpha=-25; %determines closeness of contour elements, set somewhere between [-30 30]
    %see Li & Gilbert 2002
    Alpha=(90+Alpha)/90;
    
    SegmX=zeros(2,PatchSize,PatchSize);
    SegmY=zeros(2,PatchSize,PatchSize);
    % make grid
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=i*BinSize;
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=j*BinSize;
        end
    end
    
    % turn grid around crossing with y-axis
    [SegmTheta,SegmRho] = cart2pol(zeros(2,PatchSize,PatchSize),SegmY);
    SegmTheta(SegmTheta>0)=SegmTheta(SegmTheta>0)/Alpha;
    SegmTheta(SegmTheta<0)=((SegmTheta(SegmTheta<0)+pi)/Alpha)-pi;
    [SegmXA,SegmY] = pol2cart(SegmTheta,SegmRho);
    SegmX=SegmX+SegmXA;
    
    % Draw background with the grid as center
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            angle=rand*180;
            if i==j & i>-ContLengthHalf &i<ContLengthHalf %for contour segments
                angle=45;
                X=[-SegmLength/2 SegmLength/2];
                Y=[0 0];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
            else
                JX=SegmJitter*2*(rand-0.5); %introduce jitter on non contour segments only
                JY=SegmJitter*2*(rand-0.5);
                X=[-SegmLength/2 SegmLength/2]+JX;
                Y=[0 0]-JY;
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi;
                [X,Y] = pol2cart(Theta,Rho);
            end
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+X';
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+Y';
        end
    end
    
    
    %plot all line segments
    
    
    
    
    if trialID==1
        figu=subplot(1,2,2);
    else
        subplot(1,2,1);
    end
    
    
    set(gca,'color','black')
    set(gcf,'color','black')
    
    hold on;
    
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
             if  floor(rand*11) < opacity
            plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick,'Color',[1*opacity 1*opacity 1*opacity])
             end
             end
    end
    
    hold on
    
    % Draw segments grid as center
    
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            
            if i==j & i>-ContLengthHalf &i<ContLengthHalf %for contour segments
                angle=45;
                X=[-SegmLength/2 SegmLength/2];
                Y=[0 0];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick)
            end
        end
        
    end
    
    
    
    hold off
    
    
    
    %plot mask, upper and lower part separate
    NumPoints=100;
    Radius=(PatchSizeHalf-2)*BinSize;
    Theta=linspace(0,pi,NumPoints); %100 evenly spaced points between 0 and pi
    Rho=ones(1,NumPoints)*Radius; %Radius should be 1 for all 100 points
    [X,Y] = pol2cart(Theta,Rho);
    X(101)=-PatchSize*2;
    Y(101)=0;
    X(102)=-PatchSize*2;
    Y(102)=PatchSize*2;
    X(103)=PatchSize*2;
    Y(103)=PatchSize*2;
    X(104)=PatchSize*2;
    Y(104)=0;
    patch(X,Y,'k');
    Theta=linspace(0,-pi,NumPoints); %100 evenly spaced points between 0 and -pi
    [X,Y] = pol2cart(Theta,Rho);
    X(101)=-PatchSize*2;
    Y(101)=0;
    X(102)=-PatchSize*2;
    Y(102)=-PatchSize*2;
    X(103)=PatchSize*2;
    Y(103)=-PatchSize*2;
    X(104)=PatchSize*2;
    Y(104)=0;
    patch(X,Y,'k');
    
    axis tight; axis square
   
    view(-Orient/Alpha,90)
    
    xlim([-Radius*0.8 Radius*0.8])
    ylim([-Radius*0.8 Radius*0.8])
    
    % print -dbmp LiStim1
    
    
    % SECOND PART OF FOGURE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    hold on
    % make grid
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=i*BinSize;
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=j*BinSize;
        end
    end
    
    % turn grid around crossing with y-axis
    [SegmTheta,SegmRho] = cart2pol(zeros(2,PatchSize,PatchSize),SegmY);
    SegmTheta(SegmTheta>0)=SegmTheta(SegmTheta>0)/Alpha;
    SegmTheta(SegmTheta<0)=((SegmTheta(SegmTheta<0)+pi)/Alpha)-pi;
    [SegmXA,SegmY] = pol2cart(SegmTheta,SegmRho);
    SegmX=SegmX+SegmXA;
    
    % Draw background with the grid as center
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            angle=rand*180;
            
            JX=SegmJitter*2*(rand-0.5); %introduce jitter on non contour segments only
            JY=SegmJitter*2*(rand-0.5);
            X=[-SegmLength/2 SegmLength/2]+JX;
            Y=[0 0]-JY;
            [Theta,Rho] = cart2pol(X,Y);
            Theta=Theta+angle/180*pi;
            [X,Y] = pol2cart(Theta,Rho);
            
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+X';
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+Y';
        end
    end
    
    
    %plot all line segments
    if trialID==1
        subplot(1,2,1);
    else
        subplot(1,2,2);
    end
    set(gca,'color','black')
    set(gcf,'color','black')
    
    hold on;
    
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
             if  floor(rand*11) < opacity
            plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick,'Color',[1*opacity 1*opacity 1*opacity])
             end
             end
    end
    
    hold on
    
    
    
    hold off
    
    
    
    
    %plot mask, upper and lower part separate
    NumPoints=100;
    Radius=(PatchSizeHalf-2)*BinSize;
    Theta=linspace(0,pi,NumPoints); %100 evenly spaced points between 0 and pi
    Rho=ones(1,NumPoints)*Radius; %Radius should be 1 for all 100 points
    [X,Y] = pol2cart(Theta,Rho);
    X(101)=-PatchSize*2;
    Y(101)=0;
    X(102)=-PatchSize*2;
    Y(102)=PatchSize*2;
    X(103)=PatchSize*2;
    Y(103)=PatchSize*2;
    X(104)=PatchSize*2;
    Y(104)=0;
    patch(X,Y,'k');
    Theta=linspace(0,-pi,NumPoints); %100 evenly spaced points between 0 and -pi
    [X,Y] = pol2cart(Theta,Rho);
    X(101)=-PatchSize*2;
    Y(101)=0;
    X(102)=-PatchSize*2;
    Y(102)=-PatchSize*2;
    X(103)=PatchSize*2;
    Y(103)=-PatchSize*2;
    X(104)=PatchSize*2;
    Y(104)=0;
    patch(X,Y,'k');
    hold off
    axis tight; axis square
    view(-Orient+45/Alpha,90)
    xlim([-Radius*0.8 Radius*0.8])
    ylim([-Radius*0.8 Radius*0.8])
    set(gcf,'MenuBar','none');
    
    
    positionfig=[winx winy winwidth winheight];
    
    
    %positionfig=[1600 50 500 450];
    set(fig1,'OuterPosition',positionfig) ;%move window here, also determines size
    %notusedyet=borderwidth;
else
    
    close(fig1);
    
end

end

%display training stimulus

function ShowStimulusContourTraining(unused, opacity, display, winheight,winwidth,winx,winy,crudetoggle,Orient)


fig1=figure(100);
if display==1
    
    
    
    if crudetoggle==0
        %fine
        
        ContLength=7; % length of contour
        ContLengthHalf=ceil(ContLength/2); %half of the contour
        PatchSize=9; % size of patch, pick uneven
        PatchSizeHalf=floor(PatchSize/2); %half of the patch
        SegmLength=1.2; %length of sements
        BinSize=2; %size of bins
        SegmThick=7; %line thickness9
        SegmJitter= 0.3;% jitter of segments
        
    else
        %crude
        
        ContLength=7; % length of contour
        ContLengthHalf=ceil(ContLength/2); %half of the contour
        PatchSize=11; % size of patch, pick uneven
        PatchSizeHalf=floor(PatchSize/2); %half of the patch
        SegmLength=1.2; %length of sements
        BinSize=2; %size of bins
        SegmThick=9; %line thickness9
        SegmJitter= 0.3;% jitter of segments
        
    end
    
    
    
    
    
    Alpha=-25; %determines closeness of contour elements, set somewhere between [-30 30]
    %see Li & Gilbert 2002
    Alpha=(90+Alpha)/90;
    
    SegmX=zeros(2,PatchSize,PatchSize);
    SegmY=zeros(2,PatchSize,PatchSize);
    % make grid
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=i*BinSize;
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=j*BinSize;
        end
    end
    
    % turn grid around crossing with y-axis
    [SegmTheta,SegmRho] = cart2pol(zeros(2,PatchSize,PatchSize),SegmY);
    SegmTheta(SegmTheta>0)=SegmTheta(SegmTheta>0)/Alpha;
    SegmTheta(SegmTheta<0)=((SegmTheta(SegmTheta<0)+pi)/Alpha)-pi;
    [SegmXA,SegmY] = pol2cart(SegmTheta,SegmRho);
    SegmX=SegmX+SegmXA;
    
    % Draw background with the grid as center
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            angle=rand*180;
            if i==j & i>-ContLengthHalf &i<ContLengthHalf %for contour segments
                angle=45;
                X=[-SegmLength/2 SegmLength/2];
                Y=[0 0];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
            else
                JX=SegmJitter*2*(rand-0.5); %introduce jitter on non contour segments only
                JY=SegmJitter*2*(rand-0.5);
                X=[-SegmLength/2 SegmLength/2]+JX;
                Y=[0 0]-JY;
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi;
                [X,Y] = pol2cart(Theta,Rho);
            end
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+X';
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+Y';
        end
    end
    
    
    %plot all line segments
    
    
    %both sides
    for sides = 1:2
        
        if sides == 1
            subplot(1,2,1);
        else
            subplot(1,2,2);
        end
        
        
        set(gca,'color','black')
        set(gcf,'color','black')
        
        hold on;
        
        for i=-PatchSizeHalf:PatchSizeHalf
            for j=-PatchSizeHalf:PatchSizeHalf
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick,'Color',[1*opacity 1*opacity 1*opacity])
            end
        end
        
        hold on
        
        % Draw segments grid as center
        
        for i=-PatchSizeHalf:PatchSizeHalf
            for j=-PatchSizeHalf:PatchSizeHalf
                
                if i==j & i>-ContLengthHalf &i<ContLengthHalf %for contour segments
                    angle=45;
                    X=[-SegmLength/2 SegmLength/2];
                    Y=[0 0];
                    [Theta,Rho] = cart2pol(X,Y);
                    Theta=Theta+angle/180*pi/Alpha;
                    [X,Y] = pol2cart(Theta,Rho);
                    plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick)
                end
            end
            
        end
        
        
        
        hold off
        
        
        
        %plot mask, upper and lower part separate
        NumPoints=100;
        Radius=(PatchSizeHalf-2)*BinSize;
        Theta=linspace(0,pi,NumPoints); %100 evenly spaced points between 0 and pi
        Rho=ones(1,NumPoints)*Radius; %Radius should be 1 for all 100 points
        [X,Y] = pol2cart(Theta,Rho);
        X(101)=-PatchSize*2;
        Y(101)=0;
        X(102)=-PatchSize*2;
        Y(102)=PatchSize*2;
        X(103)=PatchSize*2;
        Y(103)=PatchSize*2;
        X(104)=PatchSize*2;
        Y(104)=0;
        patch(X,Y,'k');
        Theta=linspace(0,-pi,NumPoints); %100 evenly spaced points between 0 and -pi
        [X,Y] = pol2cart(Theta,Rho);
        X(101)=-PatchSize*2;
        Y(101)=0;
        X(102)=-PatchSize*2;
        Y(102)=-PatchSize*2;
        X(103)=PatchSize*2;
        Y(103)=-PatchSize*2;
        X(104)=PatchSize*2;
        Y(104)=0;
        patch(X,Y,'k');
        
        axis tight; axis square
        
       
        view(-Orient/Alpha,90)
        
        xlim([-Radius*0.8 Radius*0.8])
        ylim([-Radius*0.8 Radius*0.8])
        
        % print -dbmp LiStim1
    end
    
    
    positionfig=[winx winy winwidth winheight];
    
    
    %positionfig=[1600 50 500 450];
    set(fig1,'OuterPosition',positionfig) ;%move window here, also determines size
    %notusedyet=borderwidth;
else
    
    close(fig1);
    
end

end



%display patch stimulus

function ShowStimulusOnePatch(this, trialID, opacity, display,winheight,winwidth,winx,winy,crudetoggle, Orient)


if crudetoggle==0
    %fine
    
    ContLength=7; % length of contour
    ContLengthHalf=ceil(ContLength/2); %half of the contour
    PatchSize=9; % size of patch, pick uneven
    PatchSizeHalf=floor(PatchSize/2); %half of the patch
    SegmLength=1.2; %length of sements
    BinSize=2; %size of bins
    SegmThick=7; %line thickness9
    SegmJitter= 0.3;% jitter of segments
    
else
    %crude
    
    ContLength=7; % length of contour
    ContLengthHalf=ceil(ContLength/2); %half of the contour
    PatchSize=11; % size of patch, pick uneven
    PatchSizeHalf=floor(PatchSize/2); %half of the patch
    SegmLength=1.2; %length of sements
    BinSize=2; %size of bins
    SegmThick=9; %line thickness9
    SegmJitter= 0.3;% jitter of segments
    
end




fig1=figure(100);

%show yes or no
if display==1
    
    
    
    
    Alpha=-25; %determines closeness of contour elements, set somewhere between [-30 30]
    %see Li & Gilbert 2002
    Alpha=(90+Alpha)/90;
    
    SegmX=zeros(2,PatchSize,PatchSize);
    SegmY=zeros(2,PatchSize,PatchSize);
    
    
    if trialID==1
        
        % make grid
        for i=-PatchSizeHalf:PatchSizeHalf
            for j=-PatchSizeHalf:PatchSizeHalf
                SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=i*BinSize;
                SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=j*BinSize;
            end
        end
        
        % turn grid around crossing with y-axis
        [SegmTheta,SegmRho] = cart2pol(zeros(2,PatchSize,PatchSize),SegmY);
        SegmTheta(SegmTheta>0)=SegmTheta(SegmTheta>0)/Alpha;
        SegmTheta(SegmTheta<0)=((SegmTheta(SegmTheta<0)+pi)/Alpha)-pi;
        [SegmXA,SegmY] = pol2cart(SegmTheta,SegmRho);
        SegmX=SegmX+SegmXA;
        
        % Draw background with the grid as center
        for i=-PatchSizeHalf:PatchSizeHalf
            for j=-PatchSizeHalf:PatchSizeHalf
                angle=rand*180;
                if i==j & i>-ContLengthHalf &i<ContLengthHalf %for contour segments
                    angle=45;
                    X=[-SegmLength/2 SegmLength/2];
                    Y=[0 0];
                    [Theta,Rho] = cart2pol(X,Y);
                    Theta=Theta+angle/180*pi/Alpha;
                    [X,Y] = pol2cart(Theta,Rho);
                else
                    JX=SegmJitter*2*(rand-0.5); %introduce jitter on non contour segments only
                    JY=SegmJitter*2*(rand-0.5);
                    X=[-SegmLength/2 SegmLength/2]+JX;
                    Y=[0 0]-JY;
                    [Theta,Rho] = cart2pol(X,Y);
                    Theta=Theta+angle/180*pi;
                    [X,Y] = pol2cart(Theta,Rho);
                end
                SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+X';
                SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+Y';
            end
        end
        
        
        %plot all line segments
        
       
        set(gca,'color','black')
        set(gcf,'color','black')
        
        hold on;
        
        for i=-PatchSizeHalf:PatchSizeHalf
            for j=-PatchSizeHalf:PatchSizeHalf
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick,'Color',[1*opacity 1*opacity 1*opacity])
            end
        end
        
        hold on
        
        % Draw segments grid as center
        
        for i=-PatchSizeHalf:PatchSizeHalf
            for j=-PatchSizeHalf:PatchSizeHalf
                
                if i==j & i>-ContLengthHalf &i<ContLengthHalf %for contour segments
                    angle=45;
                    X=[-SegmLength/2 SegmLength/2];
                    Y=[0 0];
                    [Theta,Rho] = cart2pol(X,Y);
                    Theta=Theta+angle/180*pi/Alpha;
                    [X,Y] = pol2cart(Theta,Rho);
                    plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick)
                end
            end
            
        end
        
        
        
        hold off
        
        
        
        %plot mask, upper and lower part separate
        NumPoints=100;
        Radius=(PatchSizeHalf-2)*BinSize;
        Theta=linspace(0,pi,NumPoints); %100 evenly spaced points between 0 and pi
        Rho=ones(1,NumPoints)*Radius; %Radius should be 1 for all 100 points
        [X,Y] = pol2cart(Theta,Rho);
        X(101)=-PatchSize*2;
        Y(101)=0;
        X(102)=-PatchSize*2;
        Y(102)=PatchSize*2;
        X(103)=PatchSize*2;
        Y(103)=PatchSize*2;
        X(104)=PatchSize*2;
        Y(104)=0;
        patch(X,Y,'k');
        Theta=linspace(0,-pi,NumPoints); %100 evenly spaced points between 0 and -pi
        [X,Y] = pol2cart(Theta,Rho);
        X(101)=-PatchSize*2;
        Y(101)=0;
        X(102)=-PatchSize*2;
        Y(102)=-PatchSize*2;
        X(103)=PatchSize*2;
        Y(103)=-PatchSize*2;
        X(104)=PatchSize*2;
        Y(104)=0;
        patch(X,Y,'k');
        
        axis tight; axis square
        
      
        view(-Orient/Alpha,90)
        
        xlim([-Radius*0.8 Radius*0.8])
        ylim([-Radius*0.8 Radius*0.8])
        
        % print -dbmp LiStim1
        
    else
        
        % SECOND PART OF FOGURE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        hold on
        % make grid
        for i=-PatchSizeHalf:PatchSizeHalf
            for j=-PatchSizeHalf:PatchSizeHalf
                SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=i*BinSize;
                SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=j*BinSize;
            end
        end
        
        % turn grid around crossing with y-axis
        [SegmTheta,SegmRho] = cart2pol(zeros(2,PatchSize,PatchSize),SegmY);
        SegmTheta(SegmTheta>0)=SegmTheta(SegmTheta>0)/Alpha;
        SegmTheta(SegmTheta<0)=((SegmTheta(SegmTheta<0)+pi)/Alpha)-pi;
        [SegmXA,SegmY] = pol2cart(SegmTheta,SegmRho);
        SegmX=SegmX+SegmXA;
        
        % Draw background with the grid as center
        for i=-PatchSizeHalf:PatchSizeHalf
            for j=-PatchSizeHalf:PatchSizeHalf
                angle=rand*180;
                
                JX=SegmJitter*2*(rand-0.5); %introduce jitter on non contour segments only
                JY=SegmJitter*2*(rand-0.5);
                X=[-SegmLength/2 SegmLength/2]+JX;
                Y=[0 0]-JY;
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi;
                [X,Y] = pol2cart(Theta,Rho);
                
                SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+X';
                SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+Y';
            end
        end
        
        
        %plot all line segments
        
        set(gca,'color','black')
        set(gcf,'color','black')
        
        hold on;
        
        for i=-PatchSizeHalf:PatchSizeHalf
            for j=-PatchSizeHalf:PatchSizeHalf
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick,'Color',[1*opacity 1*opacity 1*opacity])
            end
        end
        
        hold on
        
        
        hold off
        
        
        
        
        %plot mask, upper and lower part separate
        NumPoints=100;
        Radius=(PatchSizeHalf-2)*BinSize;
        Theta=linspace(0,pi,NumPoints); %100 evenly spaced points between 0 and pi
        Rho=ones(1,NumPoints)*Radius; %Radius should be 1 for all 100 points
        [X,Y] = pol2cart(Theta,Rho);
        X(101)=-PatchSize*2;
        Y(101)=0;
        X(102)=-PatchSize*2;
        Y(102)=PatchSize*2;
        X(103)=PatchSize*2;
        Y(103)=PatchSize*2;
        X(104)=PatchSize*2;
        Y(104)=0;
        patch(X,Y,'k');
        Theta=linspace(0,-pi,NumPoints); %100 evenly spaced points between 0 and -pi
        [X,Y] = pol2cart(Theta,Rho);
        X(101)=-PatchSize*2;
        Y(101)=0;
        X(102)=-PatchSize*2;
        Y(102)=-PatchSize*2;
        X(103)=PatchSize*2;
        Y(103)=-PatchSize*2;
        X(104)=PatchSize*2;
        Y(104)=0;
        patch(X,Y,'k');
        hold off
        axis tight; axis square
        view(-Orient+45/Alpha,90)
        xlim([-Radius*0.8 Radius*0.8])
        ylim([-Radius*0.8 Radius*0.8])
        set(gcf,'MenuBar','none');
        
        
        positionfig=[winx winy winwidth winheight];
        %positionfig=[1600 50 500 450];
        set(fig1,'OuterPosition',positionfig) ;%move window here, also determines size
        %notusedyet=borderwidth;
        
    end
else
    
    close(fig1);
    
end

end
