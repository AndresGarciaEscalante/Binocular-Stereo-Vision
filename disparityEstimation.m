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
%     % New leftImage (Bigger)
%     biggerImgLeftRows    = leftImageRows+windowOffset*2;    %NumberOfRowsLeftImage 
%     biggerImgLeftColumns = leftImageColumns+windowOffset*2; %NumberOfColumnsLeftImage 
%     % New RightImage (Bigger)
%     biggerImgRightRows    = rightImageRows+windowOffset*2;    %NumberOfRowRightImage 
%     biggerImgRightColumns = rightImageColumns+windowOffset*4; %NumberOfRowsRightImage (Special Case[It is used in the for loop])
    
    % New leftImage (Bigger)
    biggerImgLeftRows    = leftImageRows+windowOffset*2;    %NumberOfRowsLeftImage 
    biggerImgLeftColumns = leftImageColumns+windowOffset*4; %NumberOfColumnsLeftImage 
    % New RightImage (Bigger)
    biggerImgRightRows    = rightImageRows+windowOffset*2;    %NumberOfRowRightImage 
    biggerImgRightColumns = rightImageColumns+windowOffset*2; %NumberOfRows
    
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
    biggerImgLeft  = uint8(zeros(biggerImgLeftRows,biggerImgLeftColumns,3));  
    biggerImgRight = uint8(ones(biggerImgRightRows,biggerImgRightColumns,3)*255);
    disparityMap   = zeros(leftImageRows,leftImageColumns); 
    eD             = ones(1,leftImageColumns);
%     Auxi           = zeros(36,biggerImgRightColumns); % The value 144 is for a 10 10 cell.
     Auxi           = zeros(900,biggerImgLeftColumns);
    %% Coding
    %Adding the image to the new matrix.
    biggerImgLeft (leftImageStartRowPosNew  : leftImageEndRowPosNew , leftImageStartColumnPosNew : leftImageEndColumnPosNew , :)  = imgLeft(:,:,:);
    biggerImgRight(rightImageStartRowPosNew : rightImageEndRowPosNew, rightImageStartColumnPosNew : rightImageEndColumnPosNew , :)= imgRight(:,:,:);   
    
%     figure
%     imshow(biggerImgLeft)
%     
%     figure
%     imshow(biggerImgRight)
    
    %%Right Image
    %Iterartion Section
   
    for i =  rightImageStartRowPosNew : rightImageEndRowPosNew           % RowPositionOfTheCenterPointOfWindow[LeftImage] (i)
        %Fill all the Values of the RightImage
        for k = leftImageStartColumnPosNew: biggerImgLeftColumns-windowOffset
            tl = biggerImgLeft(i-windowOffset : windowSize+i-1-windowOffset  ,  k-windowOffset : windowSize+k-1-windowOffset,3);
            [tlFeature] = extractHOGFeatures(tl,'CellSize',[5 5]);
            Auxi(:,k-windowOffset)=tlFeature;
        end
        
        for j = rightImageStartColumnPosNew : rightImageEndColumnPosNew % ColumnPositionOfTheCenterPointOfWindow[LeftImage] (j)
            tr = biggerImgRight(i-windowOffset:windowSize+i-1-windowOffset,j-windowOffset:windowSize+j-1-windowOffset,3); %Extract Template from Left Image
            [trFeature] = extractHOGFeatures(tr,'CellSize',[5 5]); %Apply HoG to the Template
             for l = j : windowOffset*2+j
                 eD(l-windowOffset)= sqrt(sum((trFeature(:)-Auxi(:,l-windowOffset)).^2));  %Eclidean Distance
             end
            pos =find(eD == min(eD));% Gives the position of the smaller value in the corespondence
            eD(:)= 255;
            disparityMap(i-windowOffset,j-windowOffset) = pos(1)-(j-windowOffset); %Updates the Matrix DisparityMap
        end
    end     
    imshow(disparityMap)
    
    %%Left Image
%     %Iterartion Section
%     for i = 50 : 150           % RowPositionOfTheCenterPointOfWindow[LeftImage] (i)
%         %Fill all the Values of the RightImage
%         for k = rightImageStartColumnPosNew: biggerImgRightColumns-windowOffset
%             tr = biggerImgRight(i-windowOffset : windowSize+i-1-windowOffset  ,  k-windowOffset : windowSize+k-1-windowOffset,3);
%             [trFeature] = extractHOGFeatures(tr,'CellSize',[15 15]);
%             figure
%             imshow(tr)
%             Auxi(:,k-windowOffset)=trFeature;
%         end
%         
%         for j = 280 : 450 % ColumnPositionOfTheCenterPointOfWindow[LeftImage] (j)
%             tl = biggerImgLeft(i-windowOffset:windowSize+i-1-windowOffset,j-windowOffset:windowSize+j-1-windowOffset,3); %Extract Template from Left Image
%             [tlFeature] = extractHOGFeatures(tl,'CellSize',[15 15]); %Apply HoG to the Template
%              for l = j : windowOffset*2+j
%                  eD(l-windowOffset)= sqrt(sum((tlFeature(:)-Auxi(:,l-windowOffset)).^2));  %Eclidean Distance
%              end
%             pos =find(eD == min(eD));% Gives the position of the smaller value in the corespondence
%             eD(:)= 255;
%             disparityMap(i-windowOffset,j-windowOffset) = pos(1)-(j-windowOffset); %Updates the Matrix DisparityMap
%         end
%     end     
%     imshow(disparityMap)
    %Going to the previous folder
     cd ..\
end