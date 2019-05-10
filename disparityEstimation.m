% Andres Ricardo Garcia Escalante
% Student ID: 4335957
% Computer Vision Coursework

% dispariyEstimation: Given the names of both images (strings) that 
% will be analysed, using the Hog method, it will return the disparity 
% map (Matrix)

function disparityMap = disparityEstimation(imageLeft,imageRight)
    % Seeking the name of the Images in the Folder ExampleImages.
    try
        cd ExampleImages
        imgLeft = imread(imageLeft);   %Left Image data stored in imgLeft
        imgRight = imread(imageRight); %Rigth Image data stored in imgRight
        
    %In the case the images were not found in the ExampleImages folder,
    %an error will be displayed.
    catch
        cd ..\
        error('Please make sure that the images are inside the folder "ExampleImages"')
    end 
    
    %% Independant Variables
    % Window properties
    windowSize = 31;  %Value of the dimensions of the window (Rectangle). IMPORTANT (Only Odd Numbers)
    %% Dependant Variables
    % Window properties
    windowOffset =(windowSize-1)/2; %Offset needed to put the desired pixel in the middle. IMPORTANT ((windowSize-1)/2)
    
    % Matrixes Dimensions
    % Original leftImage 
    leftImageRows    = size(imgLeft,1);   %NumberOfRowsLeftImage 
    leftImageColumns = size(imgLeft,2);   %NumberOfColumnsLeftImage
    % Original rightImage
    rightImageRows    = size(imgRight,1); %NumberOfRowsRightImage 
    rightImageColumns = size(imgRight,2); %NumberOfColumnsRightImage 
    % New leftImage (Bigger)
    biggerImgLeftRows    = leftImageRows+windowOffset*2;    %NumberOfRowsLeftImage 
    biggerImgLeftColumns = leftImageColumns+windowOffset*2; %NumberOfColumnsLeftImage 
    % New RightImage (Bigger)
    biggerImgRightRows    = rightImageRows+windowOffset*2;    %NumberOfRowRightImage 
    biggerImgRightColumns = rightImageColumns+windowOffset*3; %NumberOfRowsRightImage (Special Case[It is used in the for loop])
    
    % Matrixes Positions (Bigger)
    % New leftImage
    leftImageStartRowPosNew     = windowOffset+1; 
    leftImageEndRowPosNew       = leftImageRows+windowOffset;
    leftImageStartColumnPosNew  = windowOffset+1;
    leftImageEndColumnPosNew    = leftImageColumns+windowOffset;
    %New rightImage
    rightImageStartRowPosNew    = windowOffset+1;
    rightImageEndRowPosNew      = rightImageRows+windowOffset;
    rightImageStartColumnPosNew = windowOffset+1;
    rightImageEndColumnPosNew   = rightImageColumns+windowOffset;
    
    % Declaring Matrices or Vectors
    % Matrices with more pixels (This Matrices must be uint8 type)
    biggerImgLeft  = uint8(zeros(biggerImgLeftRows,biggerImgLeftColumns,1));  
    biggerImgRight = uint8(ones(biggerImgRightRows,biggerImgRightColumns,1)*255);
    disparityMap   = zeros(leftImageRows,leftImageColumns); 
    eD             = ones(1,leftImageColumns);
    Auxi           = zeros(72,480);
    %% Coding
    %Adding the image to the new matrix.
    biggerImgLeft (leftImageStartRowPosNew  : leftImageEndRowPosNew , leftImageStartColumnPosNew : leftImageEndColumnPosNew , 1)  = imgLeft(:,:,1);
    biggerImgRight(rightImageStartRowPosNew : rightImageEndRowPosNew, rightImageStartColumnPosNew : rightImageEndColumnPosNew , 1)= imgRight(:,:,1);   

    for i = leftImageStartRowPosNew : leftImageEndRowPosNew           % RowPositionOfTheCenterPointOfWindow[LeftImage] (i)
        %Fill all the Values of the RightImage
        for k = rightImageStartColumnPosNew: biggerImgRightColumns-windowOffset
            tr = biggerImgRight(i-windowOffset : windowSize+i-1-windowOffset  ,  k-windowOffset : windowSize+k-1-windowOffset,1);
            [trFeature] = extractHOGFeatures(tr,'CellSize',[15 10]);
            Auxi(:,k-windowOffset)=trFeature;
        end
        
        for j = leftImageStartColumnPosNew : leftImageEndColumnPosNew % ColumnPositionOfTheCenterPointOfWindow[LeftImage] (j)
            tl = biggerImgLeft(i-windowOffset:windowSize+i-1-windowOffset,j-windowOffset:windowSize+j-1-windowOffset,1); %Extract Template from Left Image
            [tlFeature] = extractHOGFeatures(tl,'CellSize',[15 10]); %Apply HoG to the Template
             for l = j : windowOffset+j
                 eD(l-windowOffset)= sqrt(sum((tlFeature(:)-Auxi(:,l-windowOffset)).^2));  %Eclidean Distance
             end
            pos =find(eD == min(eD));% Gives the position of the smaller value in the corespondence
            eD(:)= 255;
            disparityMap(i-windowOffset,j-windowOffset) = pos(1)-(j-windowOffset); %Updates the Matrix DisparityMap
        end
    end      
    %Going to the previous folder
     cd ..\
 end

%#########################TO DO ##############################
    % Optimize the Code
%#############################################################
    
% %     Ploting Both Images (Report Material!!!!!!!)
%     figure
%     imshow(biggerImgLeft)
%     figure
%     imshow(biggerImgRight) %(End Report Material!!!!!!!) 

%     %Extract the template from the new matrix (Report Material!!!!!!!) 
%     ta = biggerImgLeft(1:windowSize+1-1,1:windowSize+1-1,1);
%     [taFeature,tahogVisualization] = extractHOGFeatures(ta,'CellSize',[15 10]);
%     tb = biggerImgRight(1:windowSize+1-1,1:windowSize+1-1,:);
%     [tbFeature,tbhogVisualization] = extractHOGFeatures(tb,'CellSize',[15 10]);
%     figure('Name', "Templates Image Left and Image Right"); 
%     %Plotting the Template A
%     subplot(2,1,1);
%     imshow(ta); 
%     hold on;
%     plot(tahogVisualization);
%     rectangle('Position',[1, 1, 30, 30],'LineWidth',1, 'EdgeColor', 'r')
%     hold off
%     %Plotting the Template B
%     subplot(2,1,2);
%     imshow(tb); 
%     hold on;
%     plot(tbhogVisualization);
%     rectangle('Position',[1, 1, 30, 30],'LineWidth',1, 'EdgeColor', 'b')
%     hold off                                               % (End Report Material!!!!!!!) 
%     disparityMap = taFeature;
    
    
%   Iteration Zone
%     for i = windowOffset+1:leftImageRows+windowOffset 
%       for j = windowOffset+1:leftImageColumns+windowOffset
%           for jj = windowOffset+1: rightImageColumns+windowOffset

