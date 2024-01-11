type state = {
  error: Js.Nullable.t<Js.Exn.t>,
  fetchKey: string,
}

type params<'error> = {
  error: 'error,
  fetchKey: string,
  retry: unit => unit,
}

@react.component @module("./ErrorBoundaryWithRetry.jsx")
external make: (
  ~children: state => React.element,
  ~fallback: params<Js.Exn.t> => React.element,
) => React.element = "default"
