package nmatch3.models {
    public class LocationVO {
        private var _shape:LocationShapeVO;

        public function LocationVO(pShape:LocationShapeVO) {
            _shape = pShape;
        }

        public function get shape():LocationShapeVO {
            return _shape;
        }
    }
}
