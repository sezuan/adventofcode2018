#!/usr/bin/env escript
%% -*- erlang -*-

-mode(compile).
-export([main/1]).

-define(DATA, "data.term").

main(_) ->
  Data= load_data(day3),
  MarkedFields= lists:foldl(
    fun(X,A) ->
      mark_fabric(
        field_ids(X),
        A
      )
    end, #{}, Data
  ),
  R= maps:fold(
    fun(_, V, A) ->
      case V of
        V when V > 1 -> A+1;
        V -> A
      end
    end, 0, MarkedFields
  ),
  io:format("Day 3A => ~p~n", [R]).

% {1203,347,641,29,10}

field_ids({_,X,Y,SX,SY}) ->
  ROWS=lists:seq(Y*1000, (Y+SY)*1000, 1000),
  R= lists:foldl(
    fun(B,A) ->
        [lists:seq(B+X, B+X+SX, 1)|A]
    end, [], ROWS
  ),
  lists:flatten(R).

mark_fabric(List, Fabric) ->
  lists:foldl(
    fun(X, A) ->
        V= maps:get(X, A, 0),
        maps:put(X, V+1, A)
    end, Fabric, List
  ).

%%%%%%%%%%%%
%% HELPER %%
%%%%%%%%%%%%

load_data(Day) ->
  {ok, Data}= file:consult(?DATA),
  {Day, Data1}= lists:keyfind(Day, 1, Data),
  Data1.
