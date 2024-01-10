let useQueryParams = () => {
  RescriptReactRouter.useUrl().search
  ->Webapi__Url.URLSearchParams.make
  ->Webapi__Url.URLSearchParams.entries
  ->Js.Array2.from
  ->Belt.Array.reduce(Js.Dict.empty(), (dict, tuple) => {
    let (key, value) = tuple
    Js.Dict.set(dict, key, value)
    dict
  })
}
