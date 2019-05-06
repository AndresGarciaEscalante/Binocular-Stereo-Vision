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
        imgLeft = imread(imageLeft);
        imgRight = imread(imageRight);
        %Displaying the information
        size(imgLeft)
        figure
        imshow(imgLeft);
        figure
        imshow(imgRight);
        % Going to the previous folder
        cd ..\
        disparityMap = 5;
    %In the case the images were not found in the ExampleImages folder,
    %an error will be displayed.
    catch
        cd ..\
        error('Please make sure that the images are inside the folder "ExampleImages"')
    end 
end

%% Read the first to see how large it should be
%im = imread(filenames{1});
%data = repmat(uint8(0),[size(im,1) size(im,2) length(filenames)]);
%for ii = 1:length(filenames)
%        data(:,:,ii) = imread(filenames{ii});
%end

%% Task 2
%% Plot frame 1
%figure('Name', "Frame 1"); imagesc(squeeze(data(:,:,1))); colormap(gray)


% %% Task 3
% %% Draw a rectangle around the face on top of the image.
% %% The rectangle should be located at location (row, col) = (76, 142)
% %% and should have (width, height) = (32, 32) pixels
% hold on 
% rectangle('Position',[142, 76, 30, 30],'LineWidth',2, 'EdgeColor', 'r')
% hold off
% 
% %% Task 4 
% %% Extract the template face from the image and plot template
% start_r = 76; 
% start_c = 142;
% sz = 32;
% tmplt = data(start_r:start_r+sz-1, start_c:start_c+sz-1, 1);
% figure('Name', "Template"); imagesc(tmplt); colormap(gray)
% 
% %% Task 5
% %% Normalise image and tmplt by dividing by 255
% %% Do Euclidean distance based-matching between the template and frame 1
% %% Plot the matching surface as a 2D image and find the location that
% %% corresponds to the min value
% %% What do you observe?
% 
% img = double(data(:, :, 1))./255;
% tmplt = double(tmplt)./255;
% score = zeros(size(img, 1)-sz, size(img, 2)-sz);
% for ii = 1:size(img, 1)-sz
%     for jj = 1:size(img, 2)-sz
%         tar = img(ii:ii+sz-1, jj:jj+sz-1);     
%         score(ii, jj) = sum((tmplt(:) - tar(:)).^2);
%     end 
% end
% figure('Name', "Distance (Task 5)"); imagesc(score); colorbar
% [posx, posy] = find(score == min(min(score)));
% best_match_ED = [posx posy]

%% Task 6
%% Now replace Euclidean Distance with cross-correlation based-matching between the template and frame 1
%% See https://en.wikipedia.org/wiki/Cross-correlation
%% Plot the correlation surface as a 2D image and find the location that
%% corresponds to the max value
%% What do you observe?

% img = double(data(:, :, 1))./255;
% tmplt = double(tmplt)./255;
% score = zeros(size(img, 1)-sz, size(img, 2)-sz);
% for ii = 1:size(img, 1)-sz
%     for jj = 1:size(img, 2)-sz
%         tar = img(ii:ii+sz-1, jj:jj+sz-1);
%         score(ii, jj) = tmplt(:)'*tar(:);
%     end 
% end
% figure('Name', "Distance (Task 6)"); imagesc(score); colorbar
% [posx, posy] = find(score == max(max(score)));
% best_match_Corr = [posx posy]
% figure('Name', "Output (Task 6)"); imagesc(squeeze(data(:,:,1))); colormap(gray)
% best_match_Corr = [posx posy];
% hold on 
% rectangle('Position',[posy, posx, 30, 30],'LineWidth',2, 'EdgeColor', 'g')
% hold off

%% Task 7
%% Repeat the above but replace correlation with zero-normalised cross-correlation
%% See https://en.wikipedia.org/wiki/Cross-correlation
%% [To note, you can also use corrcoef() in place above, as this normalises for you also.]
%% [ie. use c = corrcoef(tmplt,tar);]

% img = double(data(:, :, 1))./255;
% tmplt = double(tmplt)./255;
% score = zeros(size(img, 1)-sz, size(img, 2)-sz);
% tmplt1 = tmplt(:) - mean(tmplt(:)); 
% tmplt1 = tmplt1./norm(tmplt1);
% for ii = 1:size(img, 1)-sz
%     for jj = 1:size(img, 2)-sz
%         tar = img(ii:ii+sz-1, jj:jj+sz-1);
%         tar = tar(:) - mean(tar(:)); 
%         tar = tar./norm(tar);
%         score(ii, jj) = tmplt1(:)'*tar(:);
%     end 
% end
% [posx, posy] = find(score == max(max(score)));
% figure('Name', "Distance (Task 7)"); imagesc(score); colorbar
% figure('Name', "Output (Task 7)"); imagesc(squeeze(data(:,:,1))); colormap(gray)
% best_match_Corr = [posx posy];
% hold on 
% rectangle('Position',[posy, posx, 30, 30],'LineWidth',2, 'EdgeColor', 'g')
% hold off

%% Task 8
%% Do tracking without tmplt update
%% What do you observe?

% img = double(data(:, :, 1))./255;
% tmplt = double(tmplt)./255;
% score = zeros(size(img, 1)-sz, size(img, 2)-sz);
% tmplt1 = tmplt(:) - mean(tmplt(:)); 
% tmplt1 = tmplt1./norm(tmplt1);
% for dd = 1:length(filenames)
%     img = double(data(:,:,dd)); 
%     for ii = 1:size(img, 1)-sz
%         for jj = 1:size(img, 2)-sz
%             tar = img(ii:ii+sz-1, jj:jj+sz-1);
%             tar = tar(:) - mean(tar(:)); 
%             tar = tar./norm(tar);
%             score(ii, jj) = tmplt1(:)'*tar(:);
%         end 
%     end
%     [posx, posy] = find(score == max(max(score)));
%     figure; imagesc(img); colormap(gray)
%     hold on 
%     rectangle('Position',[posy, posx, 30, 30],'LineWidth',2, 'EdgeColor', 'r')
%     hold off
%     pause(0.5)
%     close all
% end

%% Task 9
%% Do tracking with tmplt update
%% What do you observe?

% img = double(data(:, :, 1))./255;
% tmplt = double(tmplt)./255;
% score = zeros(size(img, 1)-sz, size(img, 2)-sz);
% tmplt1 = tmplt(:) - mean(tmplt(:)); 
% tmplt1 = tmplt1./norm(tmplt1);
% for dd = 1:length(filenames)
%     img = double(data(:,:,dd)); 
%     for ii = 1:size(img, 1)-sz
%         for jj = 1:size(img, 2)-sz
%             tar = img(ii:ii+sz-1, jj:jj+sz-1);
%             tar = tar(:) - mean(tar(:)); 
%             tar = tar./norm(tar);
%             score(ii, jj) = tmplt1(:)'*tar(:);
%         end 
%     end
%     [posx, posy] = find(score == max(max(score)));
%     %Show tracking position:
%     hold on 
%     figure; imagesc(img); colormap(gray)
%     rectangle('Position',[posy, posx, 30, 30],'LineWidth',2, 'EdgeColor', 'r')
%     hold off
%     
%     
%     % update template
%     start_r = posx;
%     start_c = posy;
%     tmplt1 = data(start_r:start_r+sz-1, start_c:start_c+sz-1, dd);
%     figure('Name', "Template (Task 9)"); imagesc(tmplt1); colormap(gray)
%     
%     tmplt1 = double(tmplt1);
%     tmplt1 = tmplt1(:) - mean(tmplt1(:)); 
%     tmplt1 = tmplt1./norm(tmplt1);
%     
%     pause(3) % BIG PAUSE - so you can see the template updating.
%     close all
%     
% end


