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
%     imshow(biggerImgRight)

    %Extract the template from the new matrix (Report Material!!!!!!!)
    ta = biggerImgLeft(1:windowSize+1-1,1:windowSize+1-1,:);
    [taFeature,tahogVisualization] = extractHOGFeatures(ta,'CellSize',[15 10]);
    tb = biggerImgRight(1:windowSize+1-1,1:windowSize+1-1,:);
    [tbFeature,tbhogVisualization] = extractHOGFeatures(tb,'CellSize',[15 10]);
    figure('Name', "Templates Image Left and Image Right"); 
    %Plotting the Template A
    subplot(2,1,1);
    imshow(ta); 
    hold on;
    plot(tahogVisualization);
    rectangle('Position',[1, 1, 30, 30],'LineWidth',1, 'EdgeColor', 'r')
    hold off
    %Plotting the Template B
    subplot(2,1,2);
    imshow(tb); 
    hold on;
    plot(tbhogVisualization);
    rectangle('Position',[1, 1, 30, 30],'LineWidth',1, 'EdgeColor', 'b')
    hold off
    disparityMap = tbFeature;
    
    
    %#########################TO DO ##############################
    %Apply the HOG in the image for only 1 row of the new matrix
    %Observavtions: Maybe the Edges of the images should be different (White Black)
    %#############################################################
    
    
%     ta = imgLeft(1:windowSize+1-1,1:windowSize+1-1,:); % Problem
%     figure
%     imshow(ta);
    
%     % Iteration Zone
%     for i = 1: leftImageRows         % RowPositionOfTheCenterPointOfWindow (i)
%         for j = 1: leftImageColumns  % ColumnPositionOfTheCenterPointOfWindow (j) 
%             leftWindow = zeros(windowSize,windowSize); % Matrix (windowSize x windowSize)
%             ta = imgLeft(i:windowSize+i-1,j:windowSize+j-1,:); % Problem
%         end
%     end

%     % Iteration Zone
%     for i = 1: leftImageRows-1         %(i <= leftImageRows-1)
%         for j = 1: leftImageColumns-1  %(j <= leftImageColumns-1)
%             ta = imgLeft(i:windowSize+i,j:windowSize+j,:);
%             [taFeature] = extractHOGFeatures(ta,'CellSize',[15 10]);
%             for windowPos = 1: leftImageColumns-1
%                 tb = imgRight(i:windowSize+i,windowPos:leftImageColumns,:);
%                 [tbFeature] = extractHOGFeatures(tb,'CellSize',[15 10]);
%                 %Eclidean Distance     
%                 eD = sqrt(sum((taFeature(:)-tbFeature(:)).^2))
%             end
% %             if ((j == 1)&&(i == 1)) || ((j == 449)&&(i == 374))
% %                 rectangle('Position',[j-windowOffset,i-windowOffset,windowSize,windowSize],'LineWidth',1, 'EdgeColor', 'r')
% %             end
%         end
%     end
      
%     
%     hold off
%     % Extract the window's local position
%     cut= imgLeft(1:31,1:31,:); % Is it necessary to copy the 3 matrix?
%     figure
%     imshow(cut);
    








%     figure
%     imshow(imgRight);
%     %Apply Hog in the provided 
%     f= zeros(leftImageRows,leftImageColumns);
%     [featureVector,hogVisualization] = extractHOGFeatures(imgLeft,'CellSize',[10 10]); % 15 10 (6 per Window), and 10 10 (9 per window)
%     [featureVector1,hogVisualization1] = extractHOGFeatures(f,'CellSize',[10 10]); 
%     disparityMap = featureVector1;
%     disparityMap = max(disparityMap);
%     figure;
% %     imshow(imgLeft); 
%     imshow(f); 
%     hold on;
%     plot(hogVisualization1);
% %     plot(hogVisualization);
%     hold off
    







    
    %Going to the previous folder
    cd ..\
    
end



