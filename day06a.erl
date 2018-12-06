#!/usr/bin/env escript
%% -*- erlang -*-

-mode(compile).
-export([main/1]).

-define(DATA, "data.term").

main(_) ->
  Data= load_data(day6test),
  R= min_distance_s({5,0}, Data),
  io:format("Day 6A => ~p~n", [R]).


min_distance_s(Point, Points) ->
  lists:foldl(
    fun(X,{Min,ClosestPoint,Equi}) ->
      case {distance(X,Point),ClosestPoint,Equi} of
        {0, ClosestPoint, Equi} -> {Min, ClosestPoint, Equi};
        {Distance, -1, _} -> {Distance, X, false};
        {Distance, ClosestPoint, _} when Distance == Min -> {Min, X, true};
        {Distance, ClosestPoint, _} when Distance < Min -> {Distance, X, false};
        {Distance, ClosestPoint, Equi} when Distance > Min -> {Min, ClosestPoint, Equi}
      end
    end, {-1, -1, false}, Points
  ).

distance({AX,AY},{BX,BY}) ->
  abs(BX-AX) + abs(AY-BY).

%%%%%%%%%%%
%% HELPER %%
%%%%%%%%%%%%

load_data(Day) ->
  {ok, Data}= file:consult(?DATA),
  {Day, Data1}= lists:keyfind(Day, 1, Data),
  Data1.
