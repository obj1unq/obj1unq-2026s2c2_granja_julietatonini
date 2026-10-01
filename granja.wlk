import wollok.game.*




object femenino{
	method prefijo() {
		return "f"
	}
	method otro() {
		return masculino
	}
}




object masculino{
	method prefijo() {
		return "m"
	}
	method otro() {
		return femenino
	}
}





object personaje {
	var property genero = femenino

	var property position = game.center()

	const propiedad = granja

	
	method  image() {
		return genero.prefijo() + "-player-" + self.estado() + ".png"
	} 


	method estado() {
		return if (self.estaSobreAlgo())  "abajo" else "normal" 
	}


	method estaSobreAlgo() {
		return not game.colliders(self).isEmpty()
	}


	method cambiarGenero() {
		genero = genero.otro()
	}


	method plantar(cultivo) {
		propiedad.plantar(cultivo, self.position())
	} 


	method regar(){
		self.validarRegar()
		granja.cultivoAca(self.position()).regado()
	}


	method validarRegar(){
		if (not self.hayCultivoAca()) {
			self.error("no tengo nada para regar")
		}
	}


	method hayCultivoAca(){
		return granja.cultivos().any({cultivo => cultivo.position() == self.position()})
	}


	method cosechar(){
		self.validarCosechar()
		granja.cosecha(self.position())
	}


	method validarCosechar(){
		if (not self.hayCultivoAca() or not granja.cultivoAca(self.position()).estaMaduro()) {
			self.error("no se puede cosechar acá")
		}
	}
	
}





object mercado {
	const property position = game.at(5,5)

	const property image = "mercado.png"
}




object granja {
	
	const property cultivos = #{}

	const property cosechas = #{}


	method plantar(cultivo, position) {
		self.validarPlantar(cultivo, position)
		cultivo.position(position)
		cultivos.add(cultivo)
		game.addVisual(cultivo)
	}


	method validarPlantar(cultivo, position) {
		if (not self.puedePlantar(cultivo, position)) {
			self.error("No se puede plantar")
		}
	}


	method puedePlantar(cultivo, position) {
		return not cultivos.contains(cultivo) and not self.hayCultivo(position)
	}

	
	method hayCultivo(position) {
		return cultivos.any({cultivo => cultivo.position() == position})
	}


	method cultivoAca(position){
		return cultivos.find({cultivo => cultivo.position() == position})
	}


	method cosecha(position){
		const cultivo = self.cultivoAca(position)  // lo guardo en una const para no perder el cultivo, porque si lo elimino de cultivos, self.cultivoAca(position) me devuelve error
		cosechas.add(cultivo)
		cultivos.remove(cultivo)
		game.removeVisual(cultivo)
	}
}





object maiz {

	var property position = null

	var image = "maiz_bebe.png"


	method image(){
		return image
	}


	method image(newImage){
		image = newImage
	}


	method regado(){
		if (self.image() == "maiz_bebe.png") {
			self.crecer()
		}
	}


	method crecer(){
		self.image("maiz_adulto.png")
	}


	method estaMaduro(){
		return self.image() == "maiz_adulto.png"
	}
}




object trigo {

	var property position = null

	var image = "trigo_0.png"


	method image(){
		return image
	}


	method image(newImage){
		image = newImage
	}


	method regado(){
		self.evolucionar()
	}


	method evolucionar(){
		if (image == "trigo_0.png") {
			self.image("trigo_1.png")
		} else if (image == "trigo_1.png") {
			self.image("trigo_2.png")
		} else if (image == "trigo_2.png") {
			self.image("trigo_3.png") 
		} else if (image == "trigo_3.png") {
			self.image("trigo_0.png") 
		}
	}


	method estaMaduro(){
		return self.image() == "trigo_2.png" or self.image() == "trigo_3.png"
		
	}
}






object tomaco {

	var property position = null

	const property image = "tomaco.png"



	method regado() {
		const posicion = self.posicionSiguiente()
    	if (not granja.hayCultivo(posicion)) {   
        self.position(posicion)
    	}
	}



	method posicionSiguiente() {
    	if (self.position().y() == game.height() - 1) {
        	return game.at(self.position().x(), 0)
    	}
    	return game.at(self.position().x(), self.position().y() + 1)
	}


	method estaMaduro() {
		return true
	}


}