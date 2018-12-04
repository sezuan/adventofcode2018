#!/usr/bin/env escript
%% -*- erlang -*-

-mode(compile).
-export([main/1]).

-define(DATA, "data.term").

main(_) ->
  Data= load_data(day1),
  Frequency= find_loop(Data),
  io:format("Day 1B => ~p~n", [Frequency]).

find_loop(Data) -> find_loop(#{0 => true}, Data, 0).
find_loop(SeenFrequencies, [Next|Rest], Acc) ->
  Frequency= Acc + Next,
  case maps:get(Frequency, SeenFrequencies, false) of
    false ->
      find_loop(
        maps:put(Frequency, true, SeenFrequencies),
        Rest ++ [Next],
        Frequency
      );
    true -> Frequency
  end.


%%%%%%%%%%%%
%% HELPER %%
%%%%%%%%%%%%

load_data(Day) ->
  {ok, Data}= file:consult(?DATA),
  {Day, Data1}= lists:keyfind(Day, 1, Data),
  Data1.
