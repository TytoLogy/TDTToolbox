function vectordata = RPreadV(RPstruct, bufname, buflen, bufoffset)
%------------------------------------------------------------------------
% vectordata = RPreadV(RPstruct, bufname, buflen, bufoffset)
%------------------------------------------------------------------------
% TDT toolbox
%--------------------------------------------------------------------------
% Reads vector data from buffer with tag bufname on device RPstruct
% buflen is # of samples to read
%
%------------------------------------------------------------------------
% Input Arguments:
%	RPstruct				RP structure (from R?init function; e.g. RX8init)
%		RPstruct.C			activeX control handle
%		RPstruct.handle	figure handle
% 	bufname	tag name for buffer data from RP circuit
%	buflen	# of points to read from buffer
% 
%	Optional Input:
% 		bufoffset		offset to start reading data values in buffer
%
% Output Arguments:
% 	vectordata	tag value from RP circuit
%
%------------------------------------------------------------------------
% See also: RPwriteV
%------------------------------------------------------------------------

%------------------------------------------------------------------------
%  Sharad Shanbhag
%	sharad.shanbhag@einstein.yu.edu
%------------------------------------------------------------------------
% Created: 3 September, 2009
%
% Revisions:
%	15 Feb 2010 (SJS): Updated documentation
%------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if input arguments are okay
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	if nargin < 3
		error([mfilename ': bad arguments'])
	end
	if buflen <= 0
		error([mfilename ': buflen must be > 0!'])
	end
	if nargin == 3
		bufoffset = 0;
	else
		if bufoffset < 0
			warning([mfilename ': bufoffset must be > 0!'])
			bufoffset = 0;
		end
	end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read the buffer 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	vectordata = RPstruct.C.ReadTagV(bufname, bufoffset, buflen);

