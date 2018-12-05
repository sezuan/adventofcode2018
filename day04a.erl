#!/usr/bin/env escript
%% -*- erlang -*-

-mode(compile).
-export([main/1]).

-define(DATA, "data.term").

main(_) ->
  Data= load_data(day4),
  R= sort(Data),
  {Minutes, MarkedMinutes}= count_sleep(R),
  {SleepyGuard,_}= maps:fold(fun(K,V,{Guard, GuardValue}) ->
    case V > GuardValue of
      true -> {K, V};
      false -> {Guard, GuardValue}
    end end, {0,0}, Minutes),

  GuardMinutes= maps:get(SleepyGuard, MarkedMinutes),
  {MaxGuardMinutes, _}= maps:fold(fun(K,V,{Guard, GuardValue}) ->
    case V > GuardValue of
      true -> {K, V};
      false -> {Guard, GuardValue}
    end end, {0,0}, GuardMinutes),

  {R1, _}= maps:fold(
    fun(Guard, MinutesSleeps, {BestGuard, BestTimes}) ->
      {HighestMinute, HighestTimes}= maps:fold(
        fun(Minute, Times, {TopMinute, TopTimes}) ->
          case Times > TopTimes of
            true -> {Minute, Times};
            false -> {TopMinute, TopTimes}
          end
        end, {0,0}, MinutesSleeps),
      case HighestTimes > BestTimes of
        true -> {{Guard, HighestMinute}, HighestTimes};
        false -> {BestGuard, BestTimes}
      end
    end, {0,0}, MarkedMinutes),
  

  io:format("Day 4A => ~p~n", [SleepyGuard * MaxGuardMinutes]),
  io:format("Day 4B => ~p~n", [element(1,R1)*element(2,R1)]).

sort(L) ->
  lists:sort(
    fun(A,B) ->
        element(1,A) =< element(1,B)
    end, L
  ).

count_sleep(List) -> count_sleep(List, 0, #{}, #{}, 0).

% {{1518,11,9,23,56},1487,begins_shift},
% {{1518,11,10,0,39},falls_asleep},
% {{1518,11,10,0,48},wakes_up},
% {{1518,11,10,0,54},falls_asleep},
% {{1518,11,10,0,56},wakes_up},

count_sleep([],_,Acc,MarkedMinutes, _) -> {Acc, MarkedMinutes};
count_sleep([Item|List], LastGuard, Acc, MarkedMinutes, LastMinute) ->
  case Item of
    {_,Guard, begins_shift } -> 
      count_sleep(List, Guard, Acc, MarkedMinutes, LastMinute);
    {{_,_,_,_,Minute}, falls_asleep} ->
      count_sleep(List, LastGuard, Acc, MarkedMinutes, Minute);
    {{_,_,_,_,Minute}, wakes_up} ->
      SleepTime= maps:get(LastGuard, Acc, 0),
      SleepedMinutes= lists:seq(LastMinute, Minute-1),
      MM= maps:get(LastGuard, MarkedMinutes, #{}),
      MM1= lists:foldl(fun(X,A) -> Old= maps:get(X, A, 0), maps:put(X, Old+1, A) end, MM, SleepedMinutes),
      count_sleep(List, LastGuard, maps:put(LastGuard,SleepTime+Minute-LastMinute, Acc), maps:put(LastGuard, MM1, MarkedMinutes), Minute)
  end.

%%%%%%%%%%%%
%% HELPER %%
%%%%%%%%%%%%

load_data(Day) ->
  {ok, Data}= file:consult(?DATA),
  {Day, Data1}= lists:keyfind(Day, 1, Data),
  Data1.
