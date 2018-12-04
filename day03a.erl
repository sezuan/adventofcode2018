#!/usr/bin/env escript
%% -*- erlang -*-

-mode(compile).
-export([main/1]).

-define(DATA, "data.term").
-define(ROWL, 1000).
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
  {R, R1}= maps:fold(
    fun(_, {V, L}, {A, S}) ->
      case V of
        V when V > 1 -> {A+1, remove_overcommitted_sets(L, S)};
        V -> {A, S}
      end
    end, {0, sets:from_list(lists:seq(1,1233))}, MarkedFields
  ),
  io:format("Day 3A => ~p~n", [R]),
  io:format("Day 3B => ~p~n", sets:to_list(R1)).

remove_overcommitted_sets(L,S) ->
  sets:fold(
    fun(X,A) ->
        sets:del_element(X, A)
    end, S, L
  ).

field_ids({ID,X,Y,SX,SY}) ->
  ROWS=lists:seq(Y*(?ROWL), (Y+SY-1)*(?ROWL), (?ROWL)),
  R= lists:foldl(
    fun(B,A) ->
        [lists:seq(B+X, B+X+SX-1, 1)|A]
    end, [], ROWS
  ),
  {ID, lists:flatten(R)}.

mark_fabric({ID, List}, Fabric) ->
  lists:foldl(
    fun(X, A) ->
        {V,S}= maps:get(X, A, {0, sets:new()}),
        maps:put(X, {V+1, sets:add_element(ID, S)}, A)
    end, Fabric, List
  ).

%%%%%%%%%%%%
%% HELPER %%
%%%%%%%%%%%%

load_data(Day) ->
  {ok, Data}= file:consult(?DATA),
  {Day, Data1}= lists:keyfind(Day, 1, Data),
  Data1.
