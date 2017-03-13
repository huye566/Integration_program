function [y,header]=precision_int16(groupObj,source,scaleWaveform)
% sees if there is any input
if (nargin == 0)
    return;
end
scale = true;
% checks to see if the source input is a valid value
validValues = {'channel1','channel2','channel3','channel4','traceA','traceB','traceC','traceD','memory1','memory2','memory3','memory4'};
scopeValues = {'C1', 'C2', 'C3', 'C4', 'TA', 'TB', 'TC', 'TD', 'M1', 'M2', 'M3', 'M4',};
idx = strmatch(source,validValues, 'exact');
% gives error if the channel is not a valid value
if (isempty(idx))
    error('Invalid SOURCE. CHANNEL must be one of: channel1, channel2, channel3, channel4,traceA, traceB, traceC, traceD, memory1, memory2, memory3 , memory4');
end
% sets the source to its property value
trueSource = scopeValues{idx};
% checks to see if the scale entered is a valid value
if exist('scaleWaveform', 'var')
        scale = scaleWaveform;
end

device = get(groupObj, 'Parent');
util = get(device, 'Util');
driverData = get(device, 'DriverData');
interface = get(device, 'Interface');
wd = driverData.wd;
data = [];

% stores the old user setings
oldPrecision = get(groupObj, 'Precision');
oldByteOrder = get(groupObj, 'ByteOrder');
% changes the precision and byteorder so that wave form can be read
set(groupObj, 'Precision', 'int16');
set(groupObj, 'ByteOrder', 'littleEndian');
% gets wave from the instrument
% Issue the curve transfer command.
to_interface = sprintf('%s:WaveForm? ALL',trueSource);
invoke(util, 'sendcommand', to_interface);
 % get wave from the instrument
% data = invoke(util, 'readbin', 'int8');

 % Initialize the result.
% Determine the size of each element to be read. 
%get the interface
sampleElement = cast(1, 'int8');
sampleElementProperties = whos('sampleElement');
elementSize = sampleElementProperties.bytes;
EOI = false;
headerLength = 8;
% Read and concatenate until an EOI is found.
while ~EOI
     header = fread(interface, headerLength, 'uint8');%uint8注意
     [dataLength, operationFlags, sequenceNumber] = invoke(util, 'parseheader', header);
     dataLength = dataLength/elementSize;
     data = [data; fread(interface, dataLength, 'int8')];
     EOI = operationFlags.EOI;
end
% separates the data from the descriptor block 
y = data(362:end);
header = data(1:361)';
% make sure that data was
if (isempty(data))
    error('An error occurred while reading the waveform.');
end
% Rescale the waveform is requested.
% wd.getVERTICAL_GAIN(header)%精度缩小256倍
% wd.getVERTICAL_OFFSET(header)
y_high=y(2:2:end);
y_low=y(3:2:end);
y_length=min(length(y_high),length(y_low));
y=y_high(1:y_length)*256+y_low(1:y_length);
if scale
    % rescale the Y
    y = y .* wd.getVERTICAL_GAIN(header) - wd.getVERTICAL_OFFSET(header);
end
y = y';

% Restore initial settings
set(groupObj, 'Precision', oldPrecision);
set(groupObj, 'ByteOrder', oldByteOrder);






    