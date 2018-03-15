package match3.tests.shapegeneration {
    import nmatch3.models.LocationShapeVO;

    import npooling.Pool;

    import org.flexunit.asserts.assertFalse;

    public class LocationShapeVOTest {
        private static var _pool:Pool;

        public function LocationShapeVOTest() {

        }

        [BeforeClass]
        public static function beforeClass():void {
            _pool = Pool.getInstance();
        }

        [AfterClass]
        public static function afterClass():void {
            _pool.dispose();
            _pool = null;
        }

        [Test]
        public function createTest():void {
            var shape:LocationShapeVO = _pool.get(LocationShapeVO) as LocationShapeVO;

            assertFalse(shape.disposed);

            var type:String = 'test';

            var correctShape:Vector.<Vector.<int>> = new <Vector.<int>>[];
                correctShape.push(new <int>[1,1,1,1,1,1,1,1]);
                correctShape.push(new <int>[0,0,0,0,0,0,0,0]);
                correctShape.push(new <int>[0,1,0,1,0,1,0,1]);
                correctShape.push(new <int>[0,0,0,1,1,1,1,1]);

            shape.init(type, correctShape);
        }

        [Test(expects="ArgumentError")]
        public function createTypeFailedTest():void {
            var shape:LocationShapeVO = _pool.get(LocationShapeVO) as LocationShapeVO;
                shape.init(null, null);
        }

        public function createIncorrectShapeFailedTest():void {

        }

        [Test]
        public function poolTest():void {

        }

        [Test]
        public function disposeTest():void {

        }
    }

}
