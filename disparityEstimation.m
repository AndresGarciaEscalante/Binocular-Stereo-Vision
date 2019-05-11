% Andres Ricardo Garcia Escalante
% Student ID: 4335957
% Computer Vision Coursework

% disparityEstimation(String imageLeft,String imageRight): Given the names of both images, it will calculate the 
% disparity map (horizontal).
% IMPORTANT: It is important keep the images in a folder called 'ExampleImages'
function disparityMap = disparityEstimation(imageLeft,imageRight)
    try   %Seeking the name of the Images in the Folder 'ExampleImages'.
        cd ExampleImages\              %Go to the directory 'ExampleImages'
        imgLeft = imread(imageLeft);   %Left Image data stored in imgLeft
        imgRight = imread(imageRight); %Rigth Image data stored in imgRight
   
    catch %In the case the images were not found in the ExampleImages folder, an error will be displayed.
        cd ..\                         %Return to the previous Folder
        error('Please make sure that the images are inside the folder "ExampleImages"')
    end 
    
    %% Independant Variables
    % Window properties
    windowSize = 21;  %Value of the dimensions of the window (Rectangle). IMPORTANT (Only Odd Numbers)
    %% Dependant Variables
    % Window properties
    windowOffset =(windowSize-1)/2; %Offset needed to put the desired pixel in the middle. IMPORTANT ((windowSize-1)/2)
    % Matrices Dimensions
    % Original leftImage 
    leftImageRows    = size(imgLeft,1);   %NumberOfRowsLeftImage 
    leftImageColumns = size(imgLeft,2);   %NumberOfColumnsLeftImage
    % Original rightImage
    rightImageRows    = size(imgRight,1); %NumberOfRowsRightImage 
    rightImageColumns = size(imgRight,2); %NumberOfColumnsRightImage 
    % New leftImage (Bigger)
    biggerImgLeftRows    = leftImageRows+windowOffset*2;      %NumberOfRowsLeftImage 
    biggerImgLeftColumns = leftImageColumns+windowOffset*4;   %NumberOfColumnsLeftImage (Special Case[It is used in the for loop to avoid if cases inside it])
    % New RightImage (Bigger)
    biggerImgRightRows    = rightImageRows+windowOffset*2;    %NumberOfRowRightImage 
    biggerImgRightColumns = rightImageColumns+windowOffset*2; %NumberOfRowsRightImage 
    % Matrices Positions (Bigger)
    % New leftImage
    leftImageStartRowPosNew     = windowOffset+1;                  %Initial position (Row) of the leftImage in the bigger Matrix
    leftImageEndRowPosNew       = leftImageRows+windowOffset;      %Final position (Row) of the leftImage in the bigger Matrix
    leftImageStartColumnPosNew  = windowOffset+1;                  %Initial position (Column) of the leftImage in the bigger Matrix
    leftImageEndColumnPosNew    = leftImageColumns+windowOffset;   %Final position (Column) of the leftImage in the bigger Matrix
    %New rightImage
    rightImageStartRowPosNew    = windowOffset+1;                  %Initial position (Row) of the rightImage in the bigger Matrix
    rightImageEndRowPosNew      = rightImageRows+windowOffset;     %Final position (Row) of the rightImage in the bigger Matrix
    rightImageStartColumnPosNew = windowOffset+1;                  %Initial position (Column) of the rightImage in the bigger Matrix
    rightImageEndColumnPosNew   = rightImageColumns+windowOffset;  %Final position (Column) of the rightImage in the bigger Matrix
    
    % Declaring Matrices or Vectors
    % Matrices with more pixels (This Matrices must be uint8 type)
    biggerImgLeft  = uint8(zeros(biggerImgLeftRows,biggerImgLeftColumns,3));   % BiggerImgLeft size (biggerImgLeftRows,biggerImgLeftColumns,3)
    biggerImgRight = uint8(ones(biggerImgRightRows,biggerImgRightColumns,3));  % BiggerImgRight size (biggerImgLeftRows,biggerImgLeftColumns,3)
    disparityMap   = uint8(zeros(leftImageRows,leftImageColumns));             % disparityMap same size as ImageLeft. (leftImageRows,leftImageColumns)
    nc             = zeros(1,biggerImgLeftColumns-windowOffset*2);             % Normalized Correlation Vector
    MomentVec      = zeros(windowSize*windowSize,biggerImgLeftColumns-windowOffset*2);    % Momentary Vector to store all leftImages Gradients information (Per Row)
    %% Coding
    biggerImgLeft (leftImageStartRowPosNew  : leftImageEndRowPosNew , leftImageStartColumnPosNew : leftImageEndColumnPosNew , :)  = imgLeft(:,:,:); % Insert the leftImage in the leftBiggerImage. 
    biggerImgRight(rightImageStartRowPosNew : rightImageEndRowPosNew, rightImageStartColumnPosNew : rightImageEndColumnPosNew , :)= imgRight(:,:,:);% Insert the rightImage in the rightBiggerImage.
    biggerImgLeft  = rgb2gray(biggerImgLeft); % Convert it into Gray biggerImgLeft
    biggerImgRight = rgb2gray(biggerImgRight);% Convert it into Gray biggerImgRight
    [GmagLeft, GdirLeft]   = imgradient(biggerImgLeft,'central');  % Apply Gradients method to biggerImgLeft (Matrix is 2D)
    [GmagRight, GdirRight] = imgradient(biggerImgRight,'central'); % Apply Gradients method to biggerImgRight (Matrix is 2D)
    GdirLeft(leftImageStartRowPosNew-1  : leftImageEndRowPosNew+1 , leftImageStartColumnPosNew-1 : leftImageEndColumnPosNew+1) = GdirLeft(leftImageStartRowPosNew-1  : leftImageEndRowPosNew+1 , leftImageStartColumnPosNew-1 : leftImageEndColumnPosNew+1) + 180;           % Addint 180 to only the image part(Because it has negative values from -180 to 180)
    GdirLeft = GdirLeft/360;   % Normalize the LeftDirectionMatrix
    GdirRight(rightImageStartRowPosNew-1 : rightImageEndRowPosNew+1, rightImageStartColumnPosNew-1 : rightImageEndColumnPosNew+1) = GdirRight(rightImageStartRowPosNew-1 : rightImageEndRowPosNew+1, rightImageStartColumnPosNew-1 : rightImageEndColumnPosNew+1) + 180;     % Addint 180 to only the image part(Because it has negative values from -180 to 180)
    GdirRight = GdirRight/360; % Normalize the RightDirectionMatrix
    
    %Iterartion Section
    %In this section of each Template on RightImage there will be
    %(windowOffset*2) comparison from the Templare on LeftImage
    for i = rightImageStartRowPosNew : rightImageEndRowPosNew  % RowPositionOfTheCenterPixelOfTheTemplate[RightImage] (i)
        for k = leftImageStartColumnPosNew: biggerImgLeftColumns-windowOffset*2 % RowPositionOfTheCenterPixelOfTheTemplate[LeftImage] (k)
            tl = GdirLeft(i-windowOffset : windowSize+i-1-windowOffset  ,  k-windowOffset : windowSize+k-1-windowOffset); %Extract the Template of the LeftImage size(windowSize,windowSize)
            tmplt1 = tl(:) - mean(tl(:));       % Normalized Correlation Step 1
            tmplt1 = tmplt1./norm(tmplt1);      % Normalized Correlation Step 2
            MomentVec(:,k-windowOffset)=tmplt1; % Copy each Information to the Matrix
        end
        
        for j = rightImageStartColumnPosNew : rightImageEndColumnPosNew % ColumnPositionOfTheCenterPointOfWindow[RightImage] (j)
            tr = GdirRight(i-windowOffset:windowSize+i-1-windowOffset,j-windowOffset:windowSize+j-1-windowOffset); %Extract Template from Right Image
            tmplt2 = tr(:) - mean(tr(:));        % Normalized Correlation Step 1
            tmplt2 = tmplt2./norm(tmplt2);       % Normalized Correlation Step 2
            for l = j: j+windowOffset*2  % Compare to the following neighbors (windowOffset*2 from current position)
                nc(l-windowOffset) = MomentVec(:,l-windowOffset)'*tmplt2(:);  % Calculate the Normalized Correlation from the neighbors
            end
            pos =find(nc == max(nc));% Gives the position of the smaller value in the corespondence
            nc(:)= 0; %Reser the matrix
            disparityMap(i-windowOffset,j-windowOffset) = pos(1)-(j-windowOffset); %Updates the disparityMap Matrix 
        end
    end
    imagesc(disparityMap); colorbar %Plot the Result
   % Going to the previous folder
    cd ..\
 end





























% % Seeking the name of the Images in the Folder ExampleImages.
%     try
%         cd ExampleImages
%         imgLeft = imread(imageLeft);   %Left Image data stored in imgLeft
%         imgRight = imread(imageRight); %Rigth Image data stored in imgRight
%         
%     %In the case the images were not found in the ExampleImages folder,
%     %an error will be displayed.
%     catch
%         cd ..\
%         error('Please make sure that the images are inside the folder "ExampleImages"')
%     end 
%     
%     %% Independant Variables
%     % Window properties
%     windowSize = 31;  %Value of the dimensions of the window (Rectangle). IMPORTANT (Only Odd Numbers)
%     %% Dependant Variables
%     % Window properties
%     windowOffset =(windowSize-1)/2; %Offset needed to put the desired pixel in the middle. IMPORTANT ((windowSize-1)/2)
%     
%     % Matrixes Dimensions
%     % Original leftImage 
%     leftImageRows    = size(imgLeft,1);   %NumberOfRowsLeftImage 
%     leftImageColumns = size(imgLeft,2);   %NumberOfColumnsLeftImage
%     % Original rightImage
%     rightImageRows    = size(imgRight,1); %NumberOfRowsRightImage 
%     rightImageColumns = size(imgRight,2); %NumberOfColumnsRightImage 
% %     % New leftImage (Bigger)
% %     biggerImgLeftRows    = leftImageRows+windowOffset*2;    %NumberOfRowsLeftImage 
% %     biggerImgLeftColumns = leftImageColumns+windowOffset*2; %NumberOfColumnsLeftImage 
% %     % New RightImage (Bigger)
% %     biggerImgRightRows    = rightImageRows+windowOffset*2;    %NumberOfRowRightImage 
% %     biggerImgRightColumns = rightImageColumns+windowOffset*4; %NumberOfRowsRightImage (Special Case[It is used in the for loop])
%     
%     % New leftImage (Bigger)
%     biggerImgLeftRows    = leftImageRows+windowOffset*2;    %NumberOfRowsLeftImage 
%     biggerImgLeftColumns = leftImageColumns+windowOffset*4; %NumberOfColumnsLeftImage 
%     % New RightImage (Bigger)
%     biggerImgRightRows    = rightImageRows+windowOffset*2;    %NumberOfRowRightImage 
%     biggerImgRightColumns = rightImageColumns+windowOffset*2; %NumberOfRows
%     
%     % Matrixes Positions (Bigger)
%     % New leftImage
%     leftImageStartRowPosNew     = windowOffset+1; 
%     leftImageEndRowPosNew       = leftImageRows+windowOffset;
%     leftImageStartColumnPosNew  = windowOffset+1;
%     leftImageEndColumnPosNew    = leftImageColumns+windowOffset;
%     %New rightImage
%     rightImageStartRowPosNew    = windowOffset+1;
%     rightImageEndRowPosNew      = rightImageRows+windowOffset;
%     rightImageStartColumnPosNew = windowOffset+1;
%     rightImageEndColumnPosNew   = rightImageColumns+windowOffset;
%     
%     % Declaring Matrices or Vectors
%     % Matrices with more pixels (This Matrices must be uint8 type)
%     biggerImgLeft  = uint8(zeros(biggerImgLeftRows,biggerImgLeftColumns,3));  
%     biggerImgRight = uint8(ones(biggerImgRightRows,biggerImgRightColumns,3)*255);
%     disparityMap   = zeros(leftImageRows,leftImageColumns); 
%     eD             = ones(1,leftImageColumns);
% %     Auxi           = zeros(36,biggerImgRightColumns); % The value 144 is for a 10 10 cell.
%      Auxi           = zeros(900,biggerImgLeftColumns);
%     %% Coding
%     %Adding the image to the new matrix.
%     biggerImgLeft (leftImageStartRowPosNew  : leftImageEndRowPosNew , leftImageStartColumnPosNew : leftImageEndColumnPosNew , :)  = imgLeft(:,:,:);
%     biggerImgRight(rightImageStartRowPosNew : rightImageEndRowPosNew, rightImageStartColumnPosNew : rightImageEndColumnPosNew , :)= imgRight(:,:,:);   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
%     figure
%     imshow(biggerImgLeft)
%     
%     figure
%     imshow(biggerImgRight)
    
    %%Right Image
    %Iterartion Section
   
%     for i =  rightImageStartRowPosNew : rightImageEndRowPosNew           % RowPositionOfTheCenterPointOfWindow[LeftImage] (i)
%         %Fill all the Values of the RightImage
%         for k = leftImageStartColumnPosNew: biggerImgLeftColumns-windowOffset
%             tl = biggerImgLeft(i-windowOffset : windowSize+i-1-windowOffset  ,  k-windowOffset : windowSize+k-1-windowOffset,3);
%             [tlFeature] = extractHOGFeatures(tl,'CellSize',[5 5]);
%             Auxi(:,k-windowOffset)=tlFeature;
%         end
%         
%         for j = rightImageStartColumnPosNew : rightImageEndColumnPosNew % ColumnPositionOfTheCenterPointOfWindow[LeftImage] (j)
%             tr = biggerImgRight(i-windowOffset:windowSize+i-1-windowOffset,j-windowOffset:windowSize+j-1-windowOffset,3); %Extract Template from Left Image
%             [trFeature] = extractHOGFeatures(tr,'CellSize',[5 5]); %Apply HoG to the Template
%              for l = j : windowOffset*2+j
%                  eD(l-windowOffset)= sqrt(sum((trFeature(:)-Auxi(:,l-windowOffset)).^2));  %Eclidean Distance
%              end
%             pos =find(eD == min(eD));% Gives the position of the smaller value in the corespondence
%             eD(:)= 255;
%             disparityMap(i-windowOffset,j-windowOffset) = pos(1)-(j-windowOffset); %Updates the Matrix DisparityMap
%         end
%     end     
%     imshow(disparityMap)
    
%      cd ..\
% end