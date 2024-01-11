@react.component
let make = (~error, ~retry) => {
  <div>
    <div>
      {switch error->Js.Exn.message {
      | Some(message) => message
      | None => "An error occurred"
      }->React.string}
    </div>
    <button onClick={_event => retry()}> {"Retry"->React.string} </button>
  </div>
}
