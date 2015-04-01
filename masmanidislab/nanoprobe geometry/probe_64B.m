%Caltech nanoprobe type 'B'
%Note: for probes with multiple shafts, shaft 1 should be centered near x=0
%and other shafts should be at x>0 when probes are pointing downward.

exceldata=[];

exceldata=[
          
1	20	871	1
2	20	816	1
3	20	761	1
4	20	706	1
5	20	651	1
6	20	596	1
7	20	541	1
8	20	486	1
9	20	431	1
10	20	376	1
11	20	321	1
12	20	266	1
13	20	211	1
14	20	156	1
15	17	100	1
16	9	40	1
17	0	0	1
18	-13	72	1
19	-20	128	1
20	-20	183	1
21	-20	238	1
22	-20	293	1
23	-20	348	1
24	-20	403	1
25	-20	458	1
26	-20	513	1
27	-20	568	1
28	-20	623	1
29	-20	678	1
30	-20	733	1
31	-20	788	1
32	-20	843	1
33	-380	843	2
34	-380	788	2
35	-380	733	2
36	-380	678	2
37	-380	623	2
38	-380	568	2
39	-380	513	2
40	-380	458	2
41	-380	403	2
42	-380	348	2
43	-380	293	2
44	-380	238	2
45	-380	183	2
46	-380	128	2
47	-387	72	2
48	-400	0	2
49	-409	40	2
50	-417	100	2
51	-420	156	2
52	-420	211	2
53	-420	266	2
54	-420	321	2
55	-420	376	2
56	-420	431	2
57	-420	486	2
58	-420	541	2
59	-420	596	2
60	-420	651	2
61	-420	706	2
62	-420	761	2
63	-420	816	2
64	-420	871	2

          
          ];
      
s=[];
s.channels=exceldata(:,1);
s.x=-1*exceldata(:,2);   %note the reference electrode is the top right channel when the probes are pointing up.
s.z=exceldata(:,3);
s.shaft=exceldata(:,4);
s.tipelectrode=52;

%%To plot the labeled channels:
% figure(1)
% close 1
% figure(1)
% plot(s.x,s.z,'.y')
% for i=1:length(s.channels)
% text(s.x(i),s.z(i),num2str(s.channels(i)),'FontSize',6)
% end
% axis equal
