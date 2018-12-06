#!/usr/bin/env escript
%% -*- erlang -*-

-mode(compile).
-export([main/1]).

-define(DATA, "data.term").

main(_) ->
  Data= load_data(day5),
  R= fold_polymer(Data),
  AllUnits= lists:seq(97, 122),
  ShortestPoly= lists:foldl(
    fun(Char, Shortest) ->
        case length(fold_polymer(remove_unit([Char], Data))) of
          L when L < Shortest orelse Shortest == -1 -> L;
          _ -> Shortest
        end
    end, -1, AllUnits
  ),
  io:format("Day 5A => ~p~n", [length(R)]),
  io:format("Day 5B => ~p~n", [ShortestPoly]).

fold_polymer([H|Rest]) ->
  fold_polymer([H], Rest).

fold_polymer(FoldedPolymer, []) -> lists:reverse(FoldedPolymer);
fold_polymer([],  [R|RestRight]) ->
  fold_polymer([R], RestRight);
fold_polymer([L|RestLeft]= Left, [R|RestRight]) ->
  case is_reactive(L, R) of
    true -> fold_polymer(RestLeft,RestRight);
    false-> fold_polymer([R|Left],RestRight)
  
  end.

remove_unit([Char], Polymer) ->
  lists:filter(
    fun(Unit) ->
        not(lower(Unit) == Char)
    end, Polymer).

lower(Char) ->
  case Char =< 90 of
    true -> Char + 32;
    false -> Char
  end.

is_reactive(Left, Right) ->
  Left /= Right andalso lower(Left) == lower(Right).

%%%%%%%%%%%%
%% HELPER %%
%%%%%%%%%%%%

load_data(Day) ->
  {ok, Data}= file:consult(?DATA),
  {Day, Data1}= lists:keyfind(Day, 1, Data),
  Data1.
