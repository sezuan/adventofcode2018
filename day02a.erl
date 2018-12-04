#!/usr/bin/env escript
%% -*- erlang -*-

-mode(compile).
-export([main/1]).

-define(DATA, "data.term").

main(_) ->
  Data= load_data(day2),
  R= lists:foldl(
    fun(B, #{2 := Z2, 3 := Z3}= A) ->
        X= count_character(B),
        case {has_n_chars(X,2), has_n_chars(X,3)} of
          {false, false} -> A;
          {true, false}  -> #{2 => Z2+1, 3 => Z3};
          {false,true}   -> #{2 => Z2, 3 => Z3+1};
          {true, true}   -> #{2 => Z2+1, 3 => Z3+1}
        end
    end, #{2 => 0, 3 => 0}, Data
   ),
  R1= maps:get(2, R) * maps:get(3, R),
  io:format("Day 2A => ~p~n", [R1]),
  R2= compare_outer(Data),
  io:format("Day 2B => ~p~n", [R2]).

count_character(S) ->
  lists:foldl(
    fun(X,A) ->
        C= maps:get(X, A, 0),
        maps:put(X, C+1, A)
    end, #{}, S
  ).

has_n_chars(D, N) ->
  case lists:keyfind(N, 2, maps:to_list(D)) of
    {_, N} -> true;
    false -> false
  end.


compare_outer([]) -> ok;
compare_outer([I|L]) ->
  case compare_inner(I, L) of
    {found, R} -> R;
    notfound -> compare_outer(L)
  end.

compare_inner(I, found) -> {found, I};
compare_inner(_I, []) -> notfound;
compare_inner(I, [J|L]) ->
  case distance(I,J) of
    1 -> compare_inner({I,J}, found);
    _ -> compare_inner(I,L)
  end.


distance(L1, L2) ->
  D= lists:zip(L1, L2),
  lists:foldl(
    fun(X,A) ->
        case X of
          {Y,Y} -> A;
          _ -> A+1
        end
    end, 0, D
  ).

%%%%%%%%%%%%
%% HELPER %%
%%%%%%%%%%%%

load_data(Day) ->
  {ok, Data}= file:consult(?DATA),
  {Day, Data1}= lists:keyfind(Day, 1, Data),
  Data1.
