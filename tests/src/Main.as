package {
    import flash.display.Sprite;

    import match3.suits.ShapeGenerationSuite;

    import org.flexunit.internals.TraceListener;

    import org.flexunit.runner.FlexUnitCore;

    public class Main extends Sprite {
        public function Main() {
            var core:FlexUnitCore = new FlexUnitCore();
                core.addListener(new TraceListener());
                core.run(ShapeGenerationSuite);
        }
    }
}
