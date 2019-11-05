function upSampledSignal= upSamplerf(upSampleBy,modulatedSignal)

    % up sampling
    upSamplingMatrix = [1 zeros(1,upSampleBy-1)];
    upSampledSignal = kron(modulatedSignal, upSamplingMatrix);
    %upSampledSignal = interpn(modulatedSignal,4);

end