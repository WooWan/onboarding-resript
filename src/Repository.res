module Fragment = %relay(`
    fragment RepositoryFragment on Repository {
      id
      name
      description @required(action: NONE)
      ...StarButtonFragment
    }
`)

@react.component
let make = (~repository: RescriptRelay.fragmentRefs<[#RepositoryFragment]>, ~isPending) => {
  let data = Fragment.use(repository)

  <div>
    {switch data {
    | None => "hello"->React.string
    | Some(repository) =>
      <li
        className={`border list-none border-gray-200 rounded-md p-4 m-4
       ${isPending ? "opacity-40" : ""}
      `}>
        <h3> {repository.name->React.string} </h3>
        <p> {repository.description->React.string} </p>
        <StarButton star={repository.fragmentRefs} />
      </li>
    }}
  </div>
}
