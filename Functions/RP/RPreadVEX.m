function matrixdata = RPreadVEX(RPstruct, bufname, buflen, bufchan, bufoffset, buftype)
%------------------------------------------------------------------------
% matrixdata = RPreadVEX(RPstruct, bufname, buflen, bufchan, bufoffset, buftype)
%------------------------------------------------------------------------
% TDT toolbox
%--------------------------------------------------------------------------
% Reads multichannel (usually) data from buffer with tag bufname on device RPstruct
% buflen is # of samples to read, buftype is data type (default is F32 or
% single), bufchan is number of channels to read
%
%------------------------------------------------------------------------
% Input Arguments:
%	RPstruct				RP structure (from R?init function; e.g. RX8init)
%		RPstruct.C			activeX control handle
%		RPstruct.handle	figure handle
% 	bufname	tag name for buffer data from RP circuit
%	buflen	# of points to read from buffer
%	bufchan	# of channels in multichannel data
%	buflen	# of points to read from buffer
% 
%	Optional Input:
% 		bufoffset		offset to start reading data values in buffer
% 								default = 0
%		buftype			data type
% 								default is 'F32', tdt equivalent of single float
% 
% Output Arguments:
% 	matrixdata	tag value from RP circuit, should be [bufchan X buflen]
%
%------------------------------------------------------------------------
% See also: RPwriteV
%------------------------------------------------------------------------

%------------------------------------------------------------------------
%  Sharad Shanbhag
%	sharad.shanbhag@einstein.yu.edu
%------------------------------------------------------------------------
% Created: 23 February, 2010 from RPreadV
%
% Revisions:
%------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if input arguments are okay
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	if nargin < 4
		error([mfilename ': bad arguments'])
	end
	if buflen <= 0
		error([mfilename ': buflen must be > 0!'])
	end
	if bufchan <= 0
		error([mfilename ': bufchan must be > 0!'])
	end
	if nargin == 4
		bufoffset = 0;
		buftype = 'F32';
	end
	if bufoffset < 0
		warning([mfilename ': bufoffset must be > 0!'])
		bufoffset = 0;
	end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read the buffer 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	matrixdata = RPstruct.C.ReadTagVEX(bufname, bufoffset, buflen, buftype, 'F64', bufchan);






