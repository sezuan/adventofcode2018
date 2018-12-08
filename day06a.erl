#!/usr/bin/env escript
%% -*- erlang -*-

-mode(compile).
-export([main/1]).

-define(DATA, "data.term").

%{1, 1}, %{1, 6},
%{8, 3}, %{3, 4},
%{5, 5}, %{8, 9}

main(_) ->
  Data= load_data(day6),
  _R= min_distance_s({6,1}, Data),
  BoundingBox= bounding_box(Data),
  AllFields= all_fields(BoundingBox),
  AllDistances= proccess_field(AllFields,
                               fun(X) ->
                                   {X, min_distance_s(X, Data)}
                               end
  ), 
  ToRemove= remove_infinite_areas(BoundingBox,AllDistances),
  io:format("Day 6A => ~p~n", [ToRemove]).

remove_infinite_areas({{XL,YL},{XH,YH}}, FieldDistance) ->
  R= lists:foldl(
    fun(Field,A) ->
      case Field of
        {_,{true,_}} -> A;
        {{X,Y},_} when XL < X andalso YL < Y andalso X < XH andalso Y < YH -> A;
        {_,{false,ClosePoint}} -> [ClosePoint|A]
      end
    end, [], FieldDistance),
  ToRemove= lists:usort(R),
  R1= lists:foldl(
    fun(X,A) ->
      {_,{Remove, Point}}= X,
      case {Remove, lists:member(Point, ToRemove)} of
        {true, _} -> A;
        {false, true} -> A;
        {false, false} -> [Point|A]
      end
    end, [], FieldDistance
  ),
  lists:foldl(
    fun(X,A) ->
      Count= maps:get(X, A, 1),
      maps:put(X, Count+1, A)
    end, #{}, R1
  ).

bounding_box(Points) ->
  {{min_from_tlist(1, Points),min_from_tlist(2, Points)},
   {max_from_tlist(1, Points), max_from_tlist(2, Points)}}.

proccess_field(Fields, F) ->
  lists:map(F, Fields).

all_fields(BoundingBox) ->
  {{XL,YL},{_, _}}= BoundingBox,
  all_fields(BoundingBox, {XL,YL}, []).

all_fields({{XL,_},{XH,YH}}= BoundingBox, {X,Y}, L) ->
  case X =< XH andalso Y =< YH of
    true -> all_fields(BoundingBox, {X+1,Y}, [{X,Y}|L]);
    false ->
      case Y =< YH of
        true -> all_fields(BoundingBox, {XL,Y+1}, [{X,Y}|L]);
        false -> L
      end
  end.

min_from_tlist(Field, TList) ->
  [Min|_]= lists:usort(list_from_tuple_n(Field, TList)),
  Min.

max_from_tlist(Field, TList) ->
  [Max|_]= lists:reverse(lists:usort(list_from_tuple_n(Field, TList))),
  Max.

list_from_tuple_n(Field, List) ->
  lists:foldl(
    fun(X,A) -> [element(Field, X)|A] end, [], List
  ).

min_distance_s(Point, Points) ->
  {_, CP, EqualDistance}= lists:foldl(
    fun(X,{Min,ClosestPoint,Equi}) ->
      case distance(X,Point) of
        0  -> {0, ClosestPoint, true};
        Distance when ClosestPoint == -1 -> {Distance, X, false};
        Distance when Distance == Min -> {Min, X, true};
        Distance when Distance < Min -> {Distance, X, false};
        Distance when Distance > Min -> {Min, ClosestPoint, Equi}
      end
    end, {-1, -1, false}, Points
  ),
  {EqualDistance, CP}.

distance({AX,AY},{BX,BY}) ->
  abs(BX-AX) + abs(AY-BY).

%%%%%%%%%%%
%% HELPER %%
%%%%%%%%%%%%

load_data(Day) ->
  {ok, Data}= file:consult(?DATA),
  {Day, Data1}= lists:keyfind(Day, 1, Data),
  Data1.
