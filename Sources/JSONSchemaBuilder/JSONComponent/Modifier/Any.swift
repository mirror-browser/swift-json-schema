import JSONSchema

extension JSONSchemaComponent {
  public func eraseToAnyComponent() -> JSONComponents.AnyComponent<Self.Output> { .init(self) }
}

extension JSONComponents {
  /// Component for type erasure.
  public struct AnyComponent<Output>: JSONSchemaComponent {
    private let validate: @Sendable (JSONValue) -> Parsed<Output, ParseIssue>
    public var schemaValue: SchemaValue

    public init<Component: JSONSchemaComponent>(_ component: Component)
    where Component.Output == Output {
      self.schemaValue = component.schemaValue
      self.validate = component.parse
    }

    public func parse(_ value: JSONValue) -> Parsed<Output, ParseIssue> { validate(value) }
  }
}
