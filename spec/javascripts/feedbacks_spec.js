describe('feedbacks', function () {
    describe('validateOneOfManyRequiredFields', function () {
        it('should return true when at least one field is filled out', function () {
            setFixtures('<input class="one-of-many-required" value="Cowabunga">');
            expect(validateOneOfManyRequiredFields()).toBe(true);
        });

        it('should return false when no field are filled out', function () {
            setFixtures('<input class="one-of-many-required" value=" ">');
            expect(validateOneOfManyRequiredFields()).toBe(false);
        });

        it('should return true when multiple fields are filled out', function () {
            setFixtures('<input class="one-of-many-required" value="Cowabunga">' +
                '<input class="one-of-many-required" value="GnarShelf">');
            expect(validateOneOfManyRequiredFields()).toBe(true);
        });

        it('should return true when there are empty and filled out fields', function () {
            setFixtures('<input class="one-of-many-required" value="Cowabunga">' +
                '<input class="one-of-many-required" value="">');
            expect(validateOneOfManyRequiredFields()).toBe(true);
        });
        it('should have class required-error when any required field has no value', function () {
            setFixtures('<input class="one-of-many-required" value=" ">');
            validateOneOfManyRequiredFields(true);
            expect($('.one-of-many-required')).toHaveClass('required-error');
        });
    });
    describe('validateRequiredFields', function () {
        it('should return true when required field has a value', function () {
            setFixtures('<input class="required" value="Cowabunga">');
            expect(validateRequiredFields()).toBe(true);
        });

        it('should return false when required field has no value', function () {
            setFixtures('<input class="required" value=" ">');
            expect(validateRequiredFields()).toBe(false);
        });
        it('should have class required-error when required field has no value', function () {
            setFixtures('<input class="required" value=" ">');
            validateRequiredFields(true);
            expect($('.required')).toHaveClass('required-error');
        });
        it('should return true when multiple required fields have values', function () {
            setFixtures('<input class="required" value="Cowabunga">' +
                '<input class="required" value="GnarShelf">');
            expect(validateRequiredFields()).toBe(true);
        });

        it('should return false when there are empty and filled required fields', function () {
            setFixtures('<input class="required" value="Cowabunga">' +
                '<input class="required" value="">');
            expect(validateRequiredFields()).toBe(false);
        });
    });
    describe('validateAllRequired', function () {
        it('should return true when all validations pass', function () {
            spyOn(window, 'validateRequiredFields').and.returnValue(true);
            spyOn(window, 'validateOneOfManyRequiredFields').and.returnValue(true);
            expect(validateAllRequired()).toBe(true);
        });
        it('should change diet to primary when all validations pass', function () {
            setFixtures('<input class="button diet" id="preview-and-submit-button">');
            spyOn(window, 'validateRequiredFields').and.returnValue(true);
            spyOn(window, 'validateOneOfManyRequiredFields').and.returnValue(true);
            validateAllRequired();
            expect($('#preview-and-submit-button')).toHaveClass("primary");
        });
        it('should change primary to diet when any validation fails', function () {
            setFixtures('<input class="button primary" id="preview-and-submit-button">');
            spyOn(window, 'validateRequiredFields').and.returnValue(true);
            spyOn(window, 'validateOneOfManyRequiredFields').and.returnValue(false);
            validateAllRequired();
            expect($('#preview-and-submit-button')).toHaveClass("diet");
        });
        it('should return false when validateRequiredFields fails', function () {
            spyOn(window, 'validateRequiredFields').and.returnValue(false);
            spyOn(window, 'validateOneOfManyRequiredFields').and.returnValue(true);
            expect(validateAllRequired()).toBe(false);
        });
        it('should return false when validateOneOfManyRequiredFields fails', function () {
            spyOn(window, 'validateRequiredFields').and.returnValue(true);
            spyOn(window, 'validateOneOfManyRequiredFields').and.returnValue(false);
            expect(validateAllRequired()).toBe(false);
        });
    });
    describe('setupRequiredErrorHandler', function() {
        it('should remove required-error from required on a change event', function () {
            setFixtures('<input class="required-error required">');
            setupRequiredErrorHandler();
            var $requiredElement = $('.required');
            $requiredElement.trigger('change');
            expect($requiredElement).not.toHaveClass("required-error");
        });
        it('should remove required-error from required on a keyup event', function () {
            setFixtures('<input class="required-error required">');
            setupRequiredErrorHandler();
            var $requiredElement = $('.required');
            $requiredElement.trigger('keyup');
            expect($requiredElement).not.toHaveClass("required-error")
        });
        it('should remove required-error from required on a input event', function () {
            setFixtures('<input class="required-error required">');
            setupRequiredErrorHandler();
            var $requiredElement = $('.required');
            $requiredElement.trigger('input');
            expect($requiredElement).not.toHaveClass("required-error")
        });
        it('should remove required-error from required on a change event', function () {
            setFixtures('<input class="required-error one-of-many-required">');
            setupRequiredErrorHandler();
            var $requiredElement = $('.one-of-many-required');
            $requiredElement.trigger('change');
            expect($requiredElement).not.toHaveClass("required-error");
        });
        it('should remove required-error from required on a keyup event', function () {
            setFixtures('<input class="required-error one-of-many-required">');
            setupRequiredErrorHandler();
            var $requiredElement = $('.one-of-many-required');
            $requiredElement.trigger('keyup');
            expect($requiredElement).not.toHaveClass("required-error")
        });
        it('should remove required-error from required on a input event', function () {
            setFixtures('<input class="required-error one-of-many-required">');
            setupRequiredErrorHandler();
            var $requiredElement = $('.one-of-many-required');
            $requiredElement.trigger('input');
            expect($requiredElement).not.toHaveClass("required-error")
        });
    });
});

