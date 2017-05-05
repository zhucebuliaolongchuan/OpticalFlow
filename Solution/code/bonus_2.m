% Compute Optical Flow Using Lucas-Kanade Algorithm
% Read in a video file.
% vidReader = VideoReader('viptraffic.avi');
vidReader = VideoReader('moving_object_small_2.m4v');

% Create optical flow object.
opticFlow = opticalFlowLK('NoiseThreshold', 0.009);

% Estimate and display the optical flow of objects in the video.
while hasFrame(vidReader)
    frameRGB = readFrame(vidReader);
    frameGray = rgb2gray(frameRGB);
    flow = estimateFlow(opticFlow,frameGray); 
    imshow(frameRGB) 
    hold on
    plot(flow,'DecimationFactor', [5 5], 'ScaleFactor', 10)
    hold off 
end