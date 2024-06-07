% Read the image.
I = imread('Parrots.jpeg');

% Convert the read RGB image to grayscale. Grayscale images are easier to
% process since they contain only intensity information, not color.
grayImage = rgb2gray(I);

% Perform a 2D Fourier transform on the grayscale image. This operation
% transforms the image from the spatial domain into the frequency domain,
% where each point represents a particular frequency contained in the spatial
% domain image.
fftImage = fft2(double(grayImage));

% Shift the zero-frequency component to the center of the spectrum. This is
% done to align the conceptual representation of the frequencies with their
% actual locations in the Fourier transform.
fftShift = fftshift(fftImage);

% Determine the size of the image for the creation of a filter.
[rows, cols] = size(grayImage);
% Calculate the center point of the image.
crow = round(rows / 2);
ccol = round(cols / 2);

% Create a mask with all zeros - this mask will be used to create the
% low-pass filter.
mask = zeros(rows, cols);

% Define the radius of the circle for the low-pass filter. Only frequencies
% within this circle (low frequencies) will pass through the filter.
r = 50;  % radius of the circle representing the low frequencies

% Generate a circular low-pass filter mask.
[x, y] = meshgrid(1:cols, 1:rows);
mask(((x - ccol).^2 + (y - crow).^2) <= r^2) = 1;

% Apply the circular low-pass filter to the shifted Fourier transform of the image.
filteredFftShift = fftShift .* mask;

% Shift the frequency components back to their original locations and
% perform an inverse Fourier transform to get the filtered image back in the
% spatial domain.
ifftShift = ifftshift(filteredFftShift);
imgBack = ifft2(ifftShift);

% Take the absolute value of the inverse Fourier transform result to get
% real values for the image intensity. This is necessary because the inverse
% Fourier transform can return complex numbers.
imgBack = abs(imgBack);

% Apply a Gaussian smoothing filter to the grayscale image. This is done in
% the spatial domain and will blur the image to reduce noise.
gaussianFiltered = imgaussfilt(grayImage, 2);

% Display original and filtered images in a figure window.
figure;
% Display the original image.
subplot(1, 3, 1); imshow(grayImage); title('Original Image');
% Display the image after frequency domain smoothing.
subplot(1, 3, 2); imshow(imgBack, []); title('Frequency Domain Smoothing');
% Display the image after spatial domain Gaussian smoothing.
subplot(1, 3, 3); imshow(gaussianFiltered); title('Spatial Domain Smoothing');


