#!/usr/bin/env escript
%% -*- erlang -*-

-mode(compile).
-export([main/1]).

-define(DATA, "data.term").

load_data(Day) ->
  {ok, Data}= file:consult(?DATA),
  {Day, Data1}= lists:keyfind(Day, 1, Data),
  Data1.

main(_) ->
  Data= load_data(day1),
  R= lists:foldl(fun(X, A) -> X+A end, 0, Data),
  io:format("Day 1A => ~p~n", [R]).

