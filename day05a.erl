#!/usr/bin/env escript
%% -*- erlang -*-

-mode(compile).
-export([main/1]).

-define(DATA, "data.term").

main(_) ->
  Data= load_data(day5test),
  io:format("Day 5A => ~p~n", [Data]).

fold_polymer([H|Rest]) ->
  compare_polymer(H, Rest).

compare_polymer([L|RestLeft], [R|RestRight]) ->
  


%%%%%%%%%%%%
%% HELPER %%
%%%%%%%%%%%%

load_data(Day) ->
  {ok, Data}= file:consult(?DATA),
  {Day, Data1}= lists:keyfind(Day, 1, Data),
  Data1.
