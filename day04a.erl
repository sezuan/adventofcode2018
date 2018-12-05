#!/usr/bin/env escript
%% -*- erlang -*-

-mode(compile).
-export([main/1]).

-define(DATA, "data.term").

main(_) ->
  Data= load_data(day4),
  R= sort(Data),

  io:format("Day 4a => ~p~n", [R]).

sort(L) ->
  lists:sort(
    fun(A,B) ->
        element(1,A) =< element(1,B)
    end, L
  ).

%%%%%%%%%%%%
%% HELPER %%
%%%%%%%%%%%%

load_data(Day) ->
  {ok, Data}= file:consult(?DATA),
  {Day, Data1}= lists:keyfind(Day, 1, Data),
  Data1.
