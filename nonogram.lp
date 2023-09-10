%
% Nonogram constraint encoding in ASP
%

#program input.

row_cnt(number_of_rows).
col_cnt(number_of_cols).

row(row_number, block_number_in_row, block_color, block_length).
col(column_number, block_number_in_column, block_color, block_length).

#program base.

%% EXAMPLE INPUTS
%row_cnt(5).
%col_cnt(5).
%
%row(0, 1, black, 3).
%row(0, 2, black, 1).
%
%col(0, 1, black, 1).
%col(1, 1, black, 1).
%col(2, 1, black, 1).
%col(4, 1, black, 1).

%%%%%%%%%
% MODEL %
%%%%%%%%%

row(0..M-1) :- row_cnt(M).
col(0..N-1) :- col_cnt(N).

field(0..M-1, 0..N-1) :- row_cnt(M), col_cnt(N).

color(COLOR) :- row(_,_,COLOR,_).
color(COLOR) :- col(_,_,COLOR,_).

% ROW BLOCKS
%%%%%%%%%%%%

% guess the beginning of this block
1 { rowblk(NR, M, BEGIN, COLOR, CNT) : col(BEGIN), BEGIN <= N-CNT } 1 :- row(M, NR, COLOR, CNT), col_cnt(N).
% color all fields of this block
s(M, BEGIN..BEGIN+CNT-1, COLOR) :- rowblk(_, M, BEGIN, COLOR, CNT).
% ensure clear borders between blocks
:- rowblk(_, M, BEGIN, COLOR, CNT), s(M, BEGIN-1, COLOR), BEGIN > 0.
:- rowblk(_, M, BEGIN, COLOR, CNT), s(M, BEGIN+CNT, COLOR), BEGIN+CNT < N, col_cnt(N).
% ensure proper order of blocks
:- rowblk(NR, M, BEGIN, _, CNT), rowblk(NR+1, M, BEGIN2, _, CNT2), BEGIN2 < BEGIN+CNT.
% reverse inference
:- s(M,N,COLOR),
   not 1{
      rowblk(NR, M, BEGIN, COLOR, CNT)
      : rowblk(NR, M, BEGIN, COLOR, CNT),
        BEGIN <= N,
        BEGIN+CNT > N
   }.


% COLUMN BLOCKS
%%%%%%%%%%%%%%%

% guess the beginning of this block
1 { colblk(NR, N, BEGIN, COLOR, CNT) : row(BEGIN), BEGIN <= M-CNT } 1 :- col(N, NR, COLOR, CNT), row_cnt(M).
% color all fields of this block
s(BEGIN..BEGIN+CNT-1, N, COLOR) :- colblk(_, N, BEGIN, COLOR, CNT).
% ensure clear borders between blocks
:- colblk(_, N, BEGIN, COLOR, CNT), s(BEGIN-1, N, COLOR), BEGIN > 0.
:- colblk(_, N, BEGIN, COLOR, CNT), s(BEGIN+CNT, N, COLOR), BEGIN+CNT < M, row_cnt(M).
% ensure proper order of blocks
:- colblk(NR, N, BEGIN, _, CNT), colblk(NR+1, N, BEGIN2, _, CNT2), BEGIN2 < BEGIN+CNT.
% reverse inference
:- s(M,N,COLOR),
   not 1{
      colblk(NR, N, BEGIN, COLOR, CNT)
      : colblk(NR, N, BEGIN, COLOR, CNT),
        BEGIN <= M,
        BEGIN+CNT > M
   }1.

%#show rowblk/5.
%#show colblk/5.
#show s/3.
#show row_cnt/1.
#show col_cnt/1.
