function outputSignal = pathshapingf(upSampleBy, pathfParm, inputSignal)


    % raised cosine filter and interpolation
    [NUM DEN] = rcosine(1, upSampleBy, 'sqrt', pathfParm);
    outputSignal = conv(NUM, inputSignal);
    
    % resizing the interpolatedSignal. remove extra bits 
    outputSignal = outputSignal(.5*(length(NUM)-1)+1:length(outputSignal)-.5*(length(NUM)-1));
    %interpolatedSignal = interpn(modulatedSignal,4);%modulatedSignal;%interpolatedSignal(.5*(length(NUM)-1)+1:length(interpolatedSignal)-.5*(length(NUM)-1));
    

end