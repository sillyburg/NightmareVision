package funkin.game.huds;

import funkin.game.huds.BaseHUD;
import funkin.scripts.FunkinScript;
import funkin.scripts.ScriptGroup;

class ScriptableHUD extends BaseHUD
{
    public var scripts:ScriptGroup;

    // i thought you couldn't add more parameters to an override?
    public override function new(parent:PlayState, name:String)
    {
        // the order of these matter
        scripts = new ScriptGroup(this);
        searchScripts(name);
        super(parent);
        this.name = name;
    }

    public function searchScripts(_name:String)
    {
        // this was just copied from playstate cuz im lazy Ok? - borja
        for (file in Paths.listAllFilesInDirectory('scripts/huds/$_name').filter(path -> FunkinScript.isHxFile(path)))
            initScript(FunkinScript.getPath(file));
    }

    // this was ALSO copied from playstate cuz im lazy Ok? - borja
    public function initScript(filePath:String, ?name:String):Null<FunkinScript>
	{
		if (scripts.exists(name ?? filePath)) return null;
		
		var script:FunkinScript = FunkinScript.fromFile(filePath, name, scripts.scriptShareables);
		if (script.__garbage)
		{
			script = FlxDestroyUtil.destroy(script);
			return null;
		}
		Logger.log('HUD script: ${filePath} intialized');

		if (script.exists('onLoad'))
            script.call('onLoad');

		scripts.addScript(script);
		return script;
	}

    public override function init():Void
    {
        scripts.call("init");
    }
	
	public override function onSongStart():Void
    {
        scripts.call("onSongStart");
    }
	
	public override function stepHit():Void
    {
        scripts.call("onStepHit");
    }
	
	public override function beatHit():Void
    {
        scripts.call("onBeatHit");
    }
	
	public override function sectionHit():Void
    {
        scripts.call("onSectionHit");
    }
	
	public override function onUpdateScore(score:Int = 0, accuracy:Float = 0, misses:Int = 0, missed:Bool = false):Void
    {
        scripts.call("onUpdateScore", [score, accuracy, misses, missed]);
    }
	
	public override function popUpScore(daRating:funkin.game.Rating, combo:Int, note:funkin.objects.note.Note):Void
    {
        scripts.call("popUpScore", [daRating, combo, note]);
    }
	
	public override function onEvent(ev:String, v1:String, v2:String, strumTime:Float):Void
    {
        scripts.call("onEvent", [ev, v1, v2, strumTime]);
    }
	
	public override function onCharacterChange()
    {
        scripts.call("onCharacterChange");
    }
	
	public override function onHealthChange(health:Float)
    {
        scripts.call("onHealthChange", [health]);
    }
	
	public override function cachePopUpScore()
    {
        scripts.call("cachePopUpScore");
    }

    public override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        scripts.call("onUpdate", [elapsed]);
    }
}