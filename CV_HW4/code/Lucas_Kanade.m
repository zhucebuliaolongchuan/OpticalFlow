toy_2 = imread('/toy-car-images-bw/toy_formatted2.png');
toy_3 = imread('/toy-car-images-bw/toy_formatted3.png');
toy_4 = imread('/toy-car-images-bw/toy_formatted4.png');
toy_5 = imread('/toy-car-images-bw/toy_formatted5.png');
toy_6 = imread('/toy-car-images-bw/toy_formatted6.png');
toy_7 = imread('/toy-car-images-bw/toy_formatted7.png');
toy_8 = imread('/toy-car-images-bw/toy_formatted8.png');
toy_9 = imread('/toy-car-images-bw/toy_formatted9.png');


% Change the toy images so that you can get the different rows of two
% consecutive images
img_1 = toy_2;
img_2 = toy_3;

sigma = 1.0;
% Apply smoothing to the toy picture
img_1_smoothed = im2double(gaussian_filter(img_1, sigma));
img_2_smoothed = im2double(gaussian_filter(img_2, sigma));

% Calculate the temporal gradient
[m, n] = size(img_1_smoothed);
It = img_2_smoothed - img_1_smoothed;
figure(1), subplot(1, 3, 1);
imagesc(It), colormap('gray'), title('Temporal Gradient Image'), axis image;

% Calculate the x spatial derivative (use toy_2_smoothed)
Ix = double(zeros(m, n));
% for i = 2:1:m
%     for j = 1:1:n
%         Ix(i, j) = img_1_smoothed(i, j) - img_1_smoothed(i - 1, j);
%     end
% end
for i = 2:1:m
    Ix(i, :) = img_1_smoothed(i, :) - img_1_smoothed(i - 1, :);
end
figure(1), subplot(1, 3, 2);
imagesc(Ix), colormap('gray'), title('X Spatial Derivative'), axis image;

% Calculate the y spatial derivative (use toy_2_smoothed)
Iy = double(zeros(m, n));
% for i = 1:1:m
%     for j = 2:1:n
%         Iy(i, j) = img_1_smoothed(i, j) - img_1_smoothed(i, j - 1);
%     end
% end
for j = 2:1:n
    Iy(:, j) = img_1_smoothed(:, j) - img_1_smoothed(:, j - 1);
end
figure(1), subplot(1, 3, 3);
imagesc(Iy), colormap('gray'), title('Y Spatial Derivative'), axis image;

% Lucas And Kanade Method to calculate Optical Flow
% define size of neighbourhood considered
kernel = ones(3);
u = double(zeros(m, n));
v = double(zeros(m, n));
% solve v = (A^T*A)^(-1) * A^T * B associated to the neighbouhood of each
% pixel of the image
for i = ceil(size(kernel,1)/2)+1:1:m-size(kernel,1)+ceil(size(kernel,1)/2)-1
    for j = ceil(size(kernel,2)/2)+1:1:n-size(kernel,2)+ceil(size(kernel,2)/2)-1
        t=1;
            for a=-ceil(size(kernel,1)/2):1:ceil(size(kernel,1)/2)
                for b=-ceil(size(kernel,1)/2):1:ceil(size(kernel,1)/2)
                    A(t,1) = Ix(i+a, j+b);
                    A(t,2) = Iy(i+a, j+b);
                    b(t) = -It(i+a, j+b);
                    t=t+1;
                end
            end
        temp = pinv(A' * A) * A' * b';
        u(i, j) = temp(1);
        v(i, j) = temp(2);
    end
end
% Plot the Lucas And Kanade Method
% spacing = 1;
% [x, y] = meshgrid(1:spacing:n, 1:spacing:m);
% figure(2), subplot(1, 2, 1), quiver(x, y, u(1:spacing:end, 1:spacing:end), v(1:spacing:end, 1:spacing:end), 'Color', 'g'), title('Lucas Kanade Normal Flow'), axis image;
% subplot(1, 2, 2), imshow(img_1), hold on, quiver(x, y, u(1:spacing:end, 1:spacing:end), v(1:spacing:end, 1:spacing:end), 'Color', 'g'), title('Lucas Kanade Normal Flow Image Overlay');
spacing = 1;
[x, y] = meshgrid(1:spacing:n, 1:spacing:m);
figure(2), subplot(1, 2, 1), quiver(x, y, u(1:spacing:end, 1:spacing:end), v(1:spacing:end, 1:spacing:end), 'linewidth', 2, 'Color', 'g'), title('Lucas Kanade Normal Flow'), axis image, axis ij, hold off;
subplot(1, 2, 2), imshow(img_1), hold on, quiver(x, y, u(1:spacing:end, 1:spacing:end), v(1:spacing:end, 1:spacing:end), 'linewidth', 2, 'Color', 'g'), title('Lucas Kanade Normal Flow Overlay');