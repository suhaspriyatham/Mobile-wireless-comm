function downSampledSignal = downSamplerf(nSampleBy, matchedFilterOutput)

    downSampledSignal = decimate(matchedFilterOutput,nSampleBy);
%     for i=1:length(matchedFilterOutput)/nSampleBy
%         downSampledSignal(i) = matchedFilterOutput(1+(i-1)*nSampleBy);
%     end

end