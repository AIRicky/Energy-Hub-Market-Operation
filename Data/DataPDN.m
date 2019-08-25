% Base value
Sb = 10;                % MW
Vb = 12.66;             % kV
Zb = Vb^2/Sb;           % O
Ib = Sb/(sqrt(3)*Vb);   % kA

% % Line
% Line No.(1)|From(2)|To(3)|Pd(kW)(4)|Qd(kW)(5)|r(6)|x(7)|r_pu(8)|x_pu(9)|R/X(10)|P-up(11)
linedata = [
        1	1	2	100	60	0.0922	0.047	0.0058	0.0029	2       9900
        2	2	3	90	40	0.493	0.2511	0.0308	0.0157	1.9618	9900
        3	3	4	120	80	0.366	0.1864	0.0228	0.0116	1.9655	9900
        4	4	5	60	30	0.3811	0.1941	0.0238	0.0121	1.9669	9900
        5	5	6	60	20	0.819	0.707	0.0511	0.0441	1.1587	9900
        6	6	7	200	100	0.1872	0.6188	0.0117	0.0386	0.3031	9900
        7	7	8	200	100	1.7114	1.2351	0.1068	0.0771	1.3852	9900
        8	8	9	60	20	1.03	0.74	0.0643	0.0462	1.3918	9900
        9	9	10	60	20	1.044	0.74	0.0651	0.0462	1.4091	9900
        10	10	11	45	30	0.1966	0.065	0.0123	0.0041	3       9900
        11	11	12	60	35	0.3744	0.1238	0.0234	0.0077	3.039	9900
        12	12	13	60	35	1.468	1.155	0.0916	0.0721	1.2705	9900
        13	13	14	120	80	0.5416	0.7129	0.0338	0.0445	0.7596	9900
        14	14	15	60	10	0.591	0.526	0.0369	0.0328	1.125	9900
        15	15	16	60	20	0.7463	0.545	0.0466	0.034	1.3706	9900
        16	16	17	60	20	1.289	1.721	0.0804	0.1074	0.7486	9900
        17	17	18	90	40	0.732	0.574	0.0457	0.0358	1.2765	9900
        18	2	19	90	40	0.164	0.1565	0.0102	0.0098	1.0408	9900
        19	19	20	90	40	1.5042	1.3554	0.0939	0.0846	1.1099	9900
        20	20	21	90	40	0.4095	0.4784	0.0255	0.0298	0.8557	9900
        21	21	22	90	40	0.7089	0.9373	0.0442	0.0585	0.7556	9900
        22	3	23	90	50	0.4512	0.3083	0.0282	0.0192	1.4688	9900
        23	23	24	420	200	0.898	0.7091	0.056	0.0442	1.267	9900
        24	24	25	420	200	0.896	0.7011	0.0559	0.0437	1.2792	9900
        25	6	26	60	25	0.203	0.1034	0.0127	0.0065	1.9538	9900
        26	26	27	60	25	0.2842	0.1447	0.0177	0.009	1.9667	9900
        27	27	28	60	20	1.059	0.9337	0.0661	0.0583	1.1338	9900
        28	28	29	120	70	0.8042	0.7006	0.0502	0.0437	1.1487	9900
        29	29	30	200	600	0.5075	0.2585	0.0317	0.0161	1.9689	9900
        30	30	31	150	70	0.9744	0.963	0.0608	0.0601	1.0116	9900
        31	31	32	210	100	0.3105	0.3619	0.0194	0.0226	0.8584	9900
        32	32	33	60	40	0.341	0.5302	0.0213	0.0331	0.6435	9900
        ];
N_line = size(linedata,1);
line_i = linedata(:,2);
line_j = linedata(:,3);
r = linedata(:,6)/Zb;
x = linedata(:,7)/Zb; 

%% PDN Bus
N_bus = 33;
Pd_ratio = [0;linedata(:,4)]/sum(linedata(:,4));    % Active load ratio
Qd_ratio = [0;linedata(:,5)]/sum(linedata(:,5));    % Reactive load ratio
Pd0 = [63 62 60 58 59 65 72 85 95 99 100 99 93 92 90 88 90 92 96 98 96 90 80 70]/15-1.5;  % MW
Qd0 = [18 16 15 14 15.5 15 16 17 18 19 20 20.5 21 20.5 21 19.5 20 20 19.5 19.5 18.5 18.5 18 18]/10;  %MVar
Pd = Pd_ratio*Pd0; 
Qd = Qd_ratio*Qd0;
Pd = Pd/Sb; % p.u 
Qd = Qd/Sb; % p.u
Pd = [zeros(1,24);Pd];
Qd = [zeros(1,24);Qd];
U2_l = 0.95^2; 
U2_u = 1.05^2;

%% PDN Gen
% Wind Gen
Wg1_u = [6.88  7.08  7.20  7.16  6.96  6.52  6.44  5.98  5.72  5.54  5.36  5.12 ...
          4.64  4.56  4.60  4.64  4.52  4.52  4.92  5.40  5.96  6.56  6.68  6.72]-4.2;% Wind Gen #1(MW)3MW
Wg1_u = Wg1_u/Sb; % p.u
Wg_l = zeros(N_bus,NT);
Wg_u = zeros(N_bus,NT);
Wg_l(Ind_GenW,:) = 0;
Wg_u(Ind_GenW,:) = [Wg1_u]; % p.u

% Gas turbine
% Location(1)|P_min MW (2)|P_max MW (3)|Q_min MVar (4)|Q_max(5) MVar|a
% $/MW^2(6)|b $/MW (7) | alpha $/MW^2 (8) | beta $/MW (9)
GenGT = [
   7    0   1.5   0   0.5   0.12   20   5   6
   13   0   2     0   1.0   0.09   18   4   5
];
ag = zeros(N_bus,1); 
bg = zeros(N_bus,1); 
alphag = zeros(N_bus,1);
betag = zeros(N_bus,1); 

Pg_GT_l = zeros(N_bus,NT);
Pg_GT_u = zeros(N_bus,NT);
Qg_GT_l = zeros(N_bus,NT);
Qg_GT_u = zeros(N_bus,NT);

Pg_GT_l(Ind_GenGT,:) = GenGT(:,2)/Sb*ones(1,NT); % p.u.
Pg_GT_u(Ind_GenGT,:) = GenGT(:,3)/Sb*ones(1,NT); % p.u.
Qg_GT_l(Ind_GenGT,:) = GenGT(:,4)/Sb*ones(1,NT); % p.u.
Qg_GT_u(Ind_GenGT,:) = GenGT(:,5)/Sb*ones(1,NT); % p.u.

ag(Ind_GenGT,:) = GenGT(:,6);% non p.u.
bg(Ind_GenGT,:) = GenGT(:,7);% non p.u.
alphag(Ind_GenGT,:) = GenGT(:,8); % non p.u.
betag(Ind_GenGT,:) = GenGT(:,9); % non p.u.

% SVG % Mvar 
% Location(1)|Max(2)|Min(3)
SVG = [ 
        3  1.5 0;
        12 2 0;
    ];
Qg_SVG_l = zeros(N_bus,NT);
Qg_SVG_u = zeros(N_bus,NT);
Qg_SVG_l(Ind_SVG,:) = ones(length(Ind_SVG),NT).*repmat(SVG(:,3)/Sb,1,24); % p.u.
Qg_SVG_u(Ind_SVG,:) = ones(length(Ind_SVG),NT).*repmat(SVG(:,2)/Sb,1,24); % p.u.

Ind_subline = zeros(N_line,2); % Index of Children line of PDN  
for i = 1: N_line
    temp = find(line_i == line_j(i));
    if  ~isempty(temp)
        Ind_subline(i,1:length(temp)) = temp;
    end
end
