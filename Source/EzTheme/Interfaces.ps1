add-type -TypeDefinition @'
public interface IPathInfo {
    string Name { get; set; }
    string Path { get; set; }
}
public interface ITheme : IPathInfo {
    string[] Modules { get; }
    object this[System.String module] { get; set; }
}
'@
