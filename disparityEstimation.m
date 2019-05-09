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
    
    %Variables
    windowSize = 31;  %Value of the dimensions of the window (Rectangle). IMPORTANT (Only Odd Numbers)
    windowOffset =15; %Offset needed to put the desired pixel in the middle. IMPORTANT ((windowSize-1)/2)
    leftImageRows = size(imgLeft,1);      %NumberOfRowsLeftImage 
    leftImageColumns = size(imgLeft,2);   %NumberOfColumnsLeftImage
    rightImageRows = size(imgRight,1);    %NumberOfRowsRightImage 
    rightImageColumns = size(imgRight,2); %NumberOfColumnsRightImage
    rightWindow = zeros(windowSize,windowSize);%Matrix (windowSize x windowSize)
    leftWindow = zeros(windowSize,windowSize); %Matrix (windowSize x windowSize)
    disparityMap = zeros(leftImageRows,leftImageColumns); %DM LeftImageSize
    % New part creating a new matrix with more pixels (This Matrices must be uint8 type)
    biggerImgLeft = uint8(zeros(leftImageRows+windowOffset*2,leftImageColumns+windowOffset*2,3));   % LeftImage + 2*WindowOffset in the edges  ********Maybe we only need 1 dimension and not 3******
    biggerImgRight = uint8(zeros(rightImageRows+windowOffset*2,rightImageColumns+windowOffset*2,3));% RightImage + 2*WindowOffset in the edges ********Maybe we only need 1 dimension and not 3******
    %Adding the image to the new matrix.
    biggerImgLeft(windowOffset+1:leftImageRows+windowOffset,windowOffset+1:leftImageColumns+windowOffset,:)= imgLeft(:,:,:);
    biggerImgRight(windowOffset+1:rightImageRows+windowOffset,windowOffset+1:rightImageColumns+windowOffset,:)= imgRight(:,:,:);

%     %Ploting Both Images (Report Material!!!!!!!)
%     figure
%     imshow(biggerImgLeft)
%     figure
%     imshow(biggerImgRight) (End Report Material!!!!!!!) 

%     %Extract the template from the new matrix (Report Material!!!!!!!) 
%     ta = biggerImgLeft(1:windowSize+1-1,1:windowSize+1-1,:);
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
%     hold off                                                (End Report Material!!!!!!!) 
    
    %#########################TO DO ##############################
    %Apply the HOG in the image for only 1 row of the new matrix
    %Observavtions: Maybe the Edges of the images should be different (White Black)
    %#############################################################
    
    % Iteration Zone
    k=0;
%     for i = windowOffset+1:leftImageRows+windowOffset 
%       for j = windowOffset+1:leftImageColumns+windowOffset
%           for jj = windowOffset+1: rightImageColumns+windowOffset
    eD = ones(rightImageColumns,1);
    for i = windowOffset+1:windowOffset+1     % RowPositionOfTheCenterPointOfWindow[LeftImage] (i)
        for j = windowOffset+1:windowOffset+1 % ColumnPositionOfTheCenterPointOfWindow[LeftImage] (j) 
            tl = biggerImgLeft(i-windowOffset:windowSize+i-1-windowOffset,j-windowOffset:windowSize+j-1-windowOffset,:); %Extract Template from Left Image
            [tlFeature] = extractHOGFeatures(tl,'CellSize',[15 10]);
            for jj = windowOffset+1: rightImageColumns+windowOffset % ColumnPositionOfTheCenterPointOfWindow[RightImage](ii)  ********Define a maximum number of Iterations******
                tr = biggerImgRight(i-windowOffset:windowSize+i-1-windowOffset,jj-windowOffset:windowSize+jj-1-windowOffset,:);
                [trFeature] = extractHOGFeatures(tr,'CellSize',[15 10]);     
                eD(jj-windowOffset)= sqrt(sum((tlFeature(:)-trFeature(:)).^2));  %Eclidean Distance
                k=k+1;
            end
            
        end
    end   
    find(min(eD))% Gives the position of the smaller value
    disp(k)
    disparityMap = eD;
    figure
    imshow(tr)    
    %Going to the previous folder
    cd ..\
end



