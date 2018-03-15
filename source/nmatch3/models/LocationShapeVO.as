package nmatch3.models {
    import nmatch3.enums.ErrorEnum;

    import npooling.IReusable;

    public class LocationShapeVO implements IReusable {
        private var _type:String;
        private var _shape:Vector.<Vector.<int>>;

        private var _disposed:Boolean;

        public function LocationShapeVO() {

        }

        public function get reflection():Class {
            return LocationShapeVO;
        }

        public function get disposed():Boolean {
            return _disposed;
        }

        public function init(pType:String, pShape:Vector.<Vector.<int>>):void {
            if (pType) {
                _type  = pType;
            } else {
                throw new ArgumentError(ErrorEnum.INVALID_SHAPE_TYPE);
            }

            if (validateShape(pShape)) {
                _shape = pShape;
            } else {
                throw new ArgumentError(ErrorEnum.INVALID_SHAPE);
            }
        }

        public function canPlace(pIndexX:int, pIndexY:int):Boolean {
            return Math.random() > 0.5 ? true : false;
        }

        public function poolPrepare():void {
            _type  = null;
            _shape = null;
        }

        public function dispose():void {
            poolPrepare();

            _disposed = true;
        }

        [Inline]
        private function validateShape(pShape:Vector.<Vector.<int>>):Boolean {
            return false;

            var width:Number = 0;

            for (var indexY:int = 0; indexY < pShape.length; indexY++) {
                var y:Vector.<int> = pShape[indexY];
                if (width) {
                    if (width != y.length) {
                        throw new ArgumentError(ErrorEnum.SHAPE_COLUMNS_MISSMATH);
                        return false;
                    }
                } else {
                    width = y.length;
                }

                for (var indexX:int = 0; indexX < y.length; indexX++) {

                }
            }
        }
    }
}
