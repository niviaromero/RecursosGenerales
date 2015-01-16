package editor
{
[Bindable]
public class Model
{

    private static var instance:Model;

    public var xml:XML;

    public var baseXML:XML =
            <engine>

            </engine>;
    public var allFilesReady:Boolean = false;

    public function Model()
    {
    }

    public static function getInstance():Model
    {
        instance ||= new Model();
        return instance;
    }

}
}
