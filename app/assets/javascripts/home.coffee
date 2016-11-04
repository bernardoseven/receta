# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

receta = angular.module('receta',[
  'templates',
  'ngRoute',
  'ngResource',
  'controllers',
])

receta.config([ '$routeProvider',
  ($routeProvider)->
    $routeProvider
      .when('/',
        templateUrl: "index.html"
        controller: 'RecipesController'
      )
])

recipes = [
  {
    id: 1
    name: 'Baked Potato w/ Cheese'
  },
  {
    id: 2
    name: 'Garlic Mashed Potatoes',
  },
  {
    id: 3
    name: 'Potatoes Au Gratin',
  },
  {
    id: 4
    name: 'Baked Brussel Sprouts',
  },
]

controllers = angular.module('controllers')
controllers.controller("RecipeController", [ '$scope', '$routeParams', '$resource', '$location', 'flash',
  ($scope,$routeParams,$resource,$location, flash)->
    Recipe = $resource('/recipes/:recipeId', { recipeId: "@id", format: 'json' },
      {
        'save':   {method:'PUT'},
        'create': {method:'POST'}
      }
    )

    if $routeParams.recipeId
      Recipe.get({recipeId: $routeParams.recipeId},
        ( (recipe)-> $scope.recipe = recipe ),
        ( (httpResponse)->
          $scope.recipe = null
          flash.error   = "There is no recipe with ID #{$routeParams.recipeId}"
        )
      )
    else
      $scope.recipe = {}

    $scope.back   = -> $location.path("/")
    $scope.edit   = -> $location.path("/recipes/#{$scope.recipe.id}/edit")
    $scope.cancel = ->
      if $scope.recipe.id
        $location.path("/recipes/#{$scope.recipe.id}")
      else
        $location.path("/")

    $scope.save = ->
      onError = (_httpResponse)-> flash.error = "Something went wrong"
      if $scope.recipe.id
        $scope.recipe.$save(
          ( ()-> $location.path("/recipes/#{$scope.recipe.id}") ),
          onError)
      else
        Recipe.create($scope.recipe,
          ( (newRecipe)-> $location.path("/recipes/#{newRecipe.id}") ),
          onError
        )

    $scope.delete = ->
      $scope.recipe.$delete()
      $scope.back()


])

