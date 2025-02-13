import React, { useState, useEffect, useRef } from 'react';
import {
	Code2,
	Play,
	Trash2,
	Terminal,
	Activity,
	GitMerge,
	Maximize2,
	Minimize2,
	Hash,
	X,
	Menu,
	ChevronDown,
} from 'lucide-react';
import Plot from 'react-plotly.js';
import { Light as SyntaxHighlighter } from 'react-syntax-highlighter';
import matlab from 'react-syntax-highlighter/dist/esm/languages/hljs/matlab';
import { atomOneDark } from 'react-syntax-highlighter/dist/esm/styles/hljs';

SyntaxHighlighter.registerLanguage('matlab', matlab);

type PlotMode =
	| 'number'
	| 'text'
	| 'none'
	| 'delta'
	| 'gauge'
	| 'lines'
	| 'markers'
	| 'lines+markers'
	| 'text+markers'
	| 'text+lines'
	| 'text+lines+markers'
	| 'number+delta'
	| 'gauge+number'
	| 'gauge+number+delta'
	| 'gauge+delta'
	| undefined;

interface PlotData {
	type: 'scatter' | 'surface' | 'heatmap';
	x: number[];
	y: number[];
	z?: number[] | number[][];
	mode?: PlotMode;
	name?: string;
}

type OutputResult =
	| { type: 'text'; data: string }
	| { type: 'plot'; data: PlotData }
	| { type: 'image'; data: string }
	| { type: 'multiple'; data: MultipleOutputItem[] }
	| null;

type InputType = 'code' | 'numerical';

interface MethodOption {
	id: string;
	label: string;
	description: string;
	inputType: 'code' | 'numerical';
	inputFormat: string;
}

interface MultipleOutputItem {
	type: 'text' | 'image';
	data: string;
}

interface MethodConfig {
	type: 'numerical' | 'code';
	label: string;
	description: string;
	options: MethodOption[];
}

const methodConfigs: Record<string, MethodConfig> = {
	0: {
		type: 'numerical',
		label: 'Mathématiques pour les MNE',
		description:
			'Principes mathématiques appliqués aux méthodes numériques en électromagnétisme',
		options: [
			{
				id: '0_0',
				label: 'Analyse 1D',
				description:
					'Approximation des dérivées par différences finies en une dimension',
				inputType: 'numerical',
				inputFormat: '[x1, x2, ..., xn]',
			},
			{
				id: '0_1',
				label: 'Analyse sur grille 2D',
				description:
					'Analyse par différences finies sur une grille bidimensionnelle',
				inputType: 'numerical',
				inputFormat: '[[x11, x12], [x21, x22], ...]',
			},
			{
				id: '0_2',
				label: 'Analyse temporelle',
				description:
					'Analyse par différences finies dans le domaine temporel',
				inputType: 'numerical',
				inputFormat: '[t1, t2, ..., tn]',
			},
		],
	},
	1: {
		type: 'code',
		label: 'Méthodes des différences finies (MDF)',
		description:
			"Résolution d'équations aux dérivées partielles par discrétisation",
		options: [
			{
				id: '1_0',
				label: "Méthode d'Euler",
				description:
					"Approche de résolution par la méthode explicite d'Euler",
				inputType: 'code',
				inputFormat: 'MATLAB function pour Euler',
			},
			{
				id: '1_1',
				label: 'Méthode de Crank-Nicholson',
				description:
					'Méthode semi-implicite pour la stabilité des solutions',
				inputType: 'code',
				inputFormat: 'MATLAB function pour Crank-Nicholson',
			},
			{
				id: '1_2',
				label: 'Méthodes itératives',
				description:
					'Techniques itératives pour la convergence des solutions',
				inputType: 'code',
				inputFormat: 'MATLAB function pour méthodes itératives',
			},
			{
				id: '1_3',
				label: 'Outil pour la résolution analytique',
				description:
					'Comparaison des solutions numériques avec les solutions analytiques',
				inputType: 'code',
				inputFormat: 'MATLAB function pour résolution analytique',
			},
			{
				id: '1_4',
				label: 'Principe de maillage',
				description:
					'Impact du maillage sur la précision des résultats',
				inputType: 'numerical',
				inputFormat: 'MATLAB function pour le maillage',
			},
			{
				id: '1_5',
				label: 'Erreurs associées à la MDF',
				description:
					'Analyse et minimisation des erreurs de troncature et de discrétisation',
				inputType: 'code',
				inputFormat: 'MATLAB function pour analyse des erreurs',
			},
			{
				id: '1_6',
				label: 'Applications',
				description:
					"Exemples d'applications de la MDF dans divers domaines",
				inputType: 'code',
				inputFormat: 'MATLAB function pour applications MDF',
			},
		],
	},
	2: {
		type: 'code',
		label: 'Méthodes des éléments finis (MEF)',
		description:
			"Résolution numérique d'équations différentielles par éléments finis",
		options: [
			{
				id: '2_0',
				label: 'Équation de Laplace',
				description:
					"Résolution de l'équation de Laplace par éléments finis",
				inputType: 'code',
				inputFormat: 'MATLAB function pour Laplace',
			},
			{
				id: '2_1',
				label: 'Équation de Poisson',
				description:
					"Résolution de l'équation de Poisson par éléments finis",
				inputType: 'code',
				inputFormat: 'MATLAB function pour Poisson',
			},
			{
				id: '2_2',
				label: 'Équation de Helmholtz',
				description:
					"Résolution de l'équation de Helmholtz par éléments finis",
				inputType: 'numerical',
				inputFormat: 'MATLAB function pour Helmholtz',
			},
		],
	},
	3: {
		type: 'code',
		label: 'Méthodes des moments (MM)',
		description:
			"Méthodes intégrales pour la résolution d'équations en électromagnétisme",
		options: [
			{
				id: '3_0',
				label: 'Galerkin - Résidus',
				description:
					'Application de la méthode de Galerkin avec fonction de résidus',
				inputType: 'code',
				inputFormat: 'MATLAB function pour résidus',
			},
			{
				id: '3_1',
				label: 'Galerkin - RésidusX',
				description:
					'Variation de la méthode de Galerkin appliquée aux résidusX',
				inputType: 'code',
				inputFormat: 'MATLAB function pour résidusX',
			},
			{
				id: '3_2',
				label: 'Rayleigh-Ritz',
				description:
					"Méthode variationnelle pour l'approximation des solutions",
				inputType: 'code',
				inputFormat: 'MATLAB function pour Rayleigh-Ritz',
			},
			{
				id: '3_3',
				label: 'Comparaison des valeurs exactes et approchées',
				description:
					'Compare les solutions exactes et approchées obtenues par MM',
				inputType: 'code',
				inputFormat: 'MATLAB function pour comparaison',
			},
			{
				id: '3_4',
				label: 'Determiner la densité de courant et evaluer le SCS',
				description:
					'Détermine la densité de courant et évalue la section efficace de diffusion (SCS)',
				inputType: 'code',
				inputFormat: 'MATLAB function pour densité de courant et SCS',
			},
			{
				id: '3_5',
				label: 'Application ligne Ruban',
				description:
					'Application de la méthode des moments à une ligne ruban',
				inputType: 'code',
				inputFormat: 'MATLAB function pour ligne ruban',
			},
			{
				id: '3_6',
				label: 'Phi approchée',
				description: 'Calcul de Phi approchée',
				inputType: 'code',
				inputFormat: 'MATLAB function pour Phi approchée',
			},
			{
				id: '3_7',
				label: 'Fonction residus 2',
				description: 'Calcul des residus 2',
				inputType: 'code',
				inputFormat: 'MATLAB function pour residus 2',
			},
			{
				id: '3_8',
				label: 'Dispersion par un système arvitraire de fils parallèles',
				description:
					'Etude de la dispersion par un système arvitraire de fils parallèles',
				inputType: 'code',
				inputFormat: 'MATLAB function pour dispersion fils parallèles',
			},
			{
				id: '3_9',
				label: "Resolution de l'equation intégrale de Hallen",
				description: "Resolution de l'equation intégrale de Hallen",
				inputType: 'code',
				inputFormat:
					'MATLAB function pour equation intégrale de Hallen',
			},
		],
	},
	4: {
		type: 'numerical',
		label: 'Procédure de maillage (PM)',
		description: 'Génération et manipulation des maillages numériques',
		options: [
			{
				id: '4_0',
				label: 'Maillage structuré',
				description: "Génération d'un maillage structuré",
				inputType: 'numerical',
				inputFormat: '[nx, ny, nz] pour les dimensions',
			},
			{
				id: '4_1',
				label: 'Maillage non structuré',
				description: "Génération d'un maillage non structuré",
				inputType: 'numerical',
				inputFormat: '[points, éléments] pour définir le maillage',
			},
			{
				id: '4_2',
				label: 'Maillage adaptatif',
				description:
					"Génération d'un maillage adaptatif basé sur une estimation d'erreur",
				inputType: 'numerical',
				inputFormat: '[maillage_initial, seuil_erreur]',
			},
		],
	},
};

const WORD_WRAP: React.CSSProperties['wordWrap'] = 'break-word';

function App() {
	const [input, setInput] = useState('');
	const [inputType, setInputType] = useState<InputType>('code');
	const [output, setOutput] = useState<OutputResult | null>(null);
	const [comments, setComments] = useState('');
	const [status, setStatus] = useState('Prêt');
	const [isFullscreen, setIsFullscreen] = useState(false);
	const [fontSize, setFontSize] = useState(14);
	const [inputHeight, setInputHeight] = useState(320);
	const resizeRef = useRef<HTMLDivElement>(null);
	const startHeightRef = useRef(0);
	const startYRef = useRef(0);
	const [isSidebarOpen, setIsSidebarOpen] = useState(true);
	const [expandedMethod, setExpandedMethod] = useState<string | null>(null);
	const [selectedOption, setSelectedOption] = useState<MethodOption | null>(
		null
	);
	const [method, setMethod] = useState<string | null>(null);
	const [isCodeFullscreen, setIsCodeFullscreen] = useState(false);
	const [matlabCode] = useState<string>('');
	const [nx, setNx] = useState('');
	const [ny, setNy] = useState('');
	const [a, setA] = useState('');
	const [b, setB] = useState('');
	
	const getImageURL = (imagePath: string) => {
		return `http://localhost:5000/results/${imagePath}`;
	};

	useEffect(() => {
		if (method) {
			const config = methodConfigs[method as keyof typeof methodConfigs];
			setInputType(config.type);
			setInput('');
		}
	}, [method]);

	useEffect(() => {
		const handleMouseMove = (e: MouseEvent) => {
			if (
				resizeRef.current &&
				resizeRef.current.classList.contains('resizing')
			) {
				const deltaY = e.clientY - startYRef.current;
				const newHeight = Math.max(
					100,
					startHeightRef.current + deltaY
				);
				setInputHeight(newHeight);
			}
		};

		const handleMouseUp = () => {
			if (resizeRef.current) {
				resizeRef.current.classList.remove('resizing');
			}
			document.body.style.cursor = 'default';
			document.removeEventListener('mousemove', handleMouseMove);
			document.removeEventListener('mouseup', handleMouseUp);
		};

		document.addEventListener('mousemove', handleMouseMove);
		document.addEventListener('mouseup', handleMouseUp);

		return () => {
			document.removeEventListener('mousemove', handleMouseMove);
			document.removeEventListener('mouseup', handleMouseUp);
		};
	}, []);

	const startResize = (e: React.MouseEvent) => {
		if (resizeRef.current) {
			resizeRef.current.classList.add('resizing');
			startHeightRef.current = inputHeight;
			startYRef.current = e.clientY;
			document.body.style.cursor = 'row-resize';
		}
	};

	const validateNumericalInput = (value: string) => {
		return /^[\d.,[\]\s\n]*$/.test(value);
	};

	const handleInputChange = (value: string) => {
		if (inputType === 'numerical' && !validateNumericalInput(value)) {
			return;
		}
		setInput(value);
	};

	const executeCode = async () => {
		if (!method || !selectedOption) {
			alert('Veuillez sélectionner une méthode et une option.');
			return;
		}

		setStatus('Exécution en cours...');

		try {
			const response = await fetch('http://localhost:5000/execute', {
				method: 'POST',
				headers: {
					'Content-Type': 'application/json',
				},
				body: JSON.stringify({
					method: selectedOption.id,
					inputType: selectedOption.inputType,
					nx: nx,
					ny: ny,
					a: a,
					b: b,
				}),
			});

			const result = await response.json();

			if (result.success) {
				// setOutput({ type: result.type, data: result.data });
				setOutput(result.result as OutputResult);
				setStatus('Exécution terminée');
			} else {
				console.error('Backend error:', result.error);
				setStatus(`Erreur: ${result.error}`);
			}
		} catch (error) {
			console.error('Erreur de récupération:', error);
			setStatus("Erreur lors de l'exécution");
		}
	};

	const clearInput = () => {
		setInput('');
		setOutput(null);
		setStatus('Prêt');
	};

	const renderInput = () => {
		const commonClasses = 'w-full rounded-lg transition-all duration-300';

		if (inputType === 'code') {
			return (
				<>
					<div
						className={commonClasses}
						style={{ height: inputHeight }}
					>
						<SyntaxHighlighter
							language='matlab'
							style={atomOneDark}
							className='h-full rounded-lg overflow-auto scrollbar-hide'
							customStyle={{
								padding: '1rem',
								fontSize: `${fontSize}px`,
								transition: 'all 0.3s',
								height: '100%',
								margin: 0,
								backgroundColor: '#0d1117',
							}}
						>
							{input || matlabCode || '% Enter MATLAB code here'}
						</SyntaxHighlighter>
						<textarea
							value={input}
							onChange={(e) => handleInputChange(e.target.value)}
							className='sr-only'
							aria-hidden='true'
						/>
					</div>

					{/* Fullscreen Modal */}
					{isCodeFullscreen && (
						<div className='fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50'>
							<div className='bg-[#0d1117] w-[95vw] h-[90vh] rounded-lg p-4'>
								<div className='flex justify-between items-center mb-4'>
									<h2 className='text-xl font-semibold'>
										MATLAB Code
									</h2>
									<button
										onClick={() =>
											setIsCodeFullscreen(false)
										}
										className='p-2 hover:bg-gray-700 rounded-lg'
									>
										<X size={20} />
									</button>
								</div>
								<SyntaxHighlighter
									language='matlab'
									style={atomOneDark}
									className='h-[calc(90vh-80px)] overflow-auto scrollbar-hide'
									customStyle={{
										padding: '1rem',
										fontSize: `${fontSize}px`,
										height: '100%',
										margin: 0,
										backgroundColor: '#0d1117',
									}}
								>
									{input ||
										matlabCode ||
										'% Entrez le code MATLAB ici'}
								</SyntaxHighlighter>
							</div>
						</div>
					)}
				</>
			);
		}

		// return (
		// <textarea
		// 	value={input}
		// 	onChange={(e) => handleInputChange(e.target.value)}
		// 	style={{ fontSize: `${fontSize}px`, height: inputHeight }}
		// 	className={`${commonClasses} bg-[#0d1117] text-[#c9d1d9] border border-[#30363d] p-4 font-mono resize-none focus:ring-2 focus:ring-[#58a6ff] focus:border-transparent`}
		// 	placeholder='Entrez des valeurs numériques (par exemple, [1, 2, 3] ou format matriciel)'
		// />
		// );
		return (
			<div>
				<div>
					<label htmlFor='nx'>nx:</label>
					<input
						type='number'
						id='nx'
						value={nx}
						onChange={(e) => setNx(e.target.value)}
						className={`${commonClasses} bg-[#0d1117] text-[#c9d1d9] border border-[#30363d] p-4 font-mono resize-none focus:ring-2 focus:ring-[#58a6ff] focus:border-transparent`}
					/>
				</div>
				<div>
					<label htmlFor='ny'>ny:</label>
					<input
						type='number'
						id='ny'
						value={ny}
						onChange={(e) => setNy(e.target.value)}
						className={`${commonClasses} bg-[#0d1117] text-[#c9d1d9] border border-[#30363d] p-4 font-mono resize-none focus:ring-2 focus:ring-[#58a6ff] focus:border-transparent`}
					/>
				</div>
				<div>
					<label htmlFor='a'>a:</label>
					<input
						type='number'
						id='a'
						value={a}
						onChange={(e) => setA(e.target.value)}
						className={`${commonClasses} bg-[#0d1117] text-[#c9d1d9] border border-[#30363d] p-4 font-mono resize-none focus:ring-2 focus:ring-[#58a6ff] focus:border-transparent`}
					/>
				</div>
				<div>
					<label htmlFor='b'>b:</label>
					<input
						type='number'
						id='b'
						value={b}
						onChange={(e) => setB(e.target.value)}
						className={`${commonClasses} bg-[#0d1117] text-[#c9d1d9] border border-[#30363d] p-4 font-mono resize-none focus:ring-2 focus:ring-[#58a6ff] focus:border-transparent`}
					/>
				</div>
			</div>
		);
	};

	const renderOutput = () => {
		if (!output) return null;

		const commonStyles = {
			fontSize: `${fontSize}px`,
			transition: 'all 0.3s',
			whiteSpace: 'pre-wrap',
			wordWrap: WORD_WRAP,
		};

		switch (output.type) {
			case 'text':
				return (
					<pre
						style={{
							...commonStyles,
							whiteSpace: 'pre-wrap',
							wordWrap: WORD_WRAP,
						}}
						className='h-full w-full overflow-auto scrollbar-hide bg-[#0d1117] p-4 rounded-lg'
					>
						{output.data as string}
					</pre>
				);

			case 'plot':
				return (
					<div className='h-full flex items-center justify-center'>
						<Plot
							data={[output.data as PlotData]}
							layout={{
								paper_bgcolor: '#0d1117',
								plot_bgcolor: '#0d1117',
								font: { color: '#c9d1d9', size: fontSize },
								margin: { t: 10, r: 10, b: 50, l: 50 },
								showlegend: true,
								width: isFullscreen
									? window.innerWidth * 0.8
									: 500,
								height: isFullscreen
									? window.innerHeight * 0.8
									: 400,
							}}
							config={{ responsive: true }}
						/>
					</div>
				);

			case 'image':
				return (
					<img
						src={getImageURL(output.data as string)}
						alt='Résultats'
					/>
				);

			case 'multiple':
				return (
					<div className='grid grid-cols-1 md:grid-cols-2 gap-4 h-full overflow-y-auto'>
						{(output.data as MultipleOutputItem[]).map(
							(item, index) => (
								<div
									key={index}
									className='bg-[#0d1117] p-4 rounded-lg'
								>
									{item.type === 'text' && (
										<pre
											style={{
												...commonStyles,
												whiteSpace: 'pre-wrap',
												wordWrap: WORD_WRAP,
											}}
											className='w-full overflow-auto scrollbar-hide'
										>
											{item.data}
										</pre>
									)}
									{item.type === 'image' && (
										<img
											src={getImageURL(item.data)}
											alt={`Résultat ${index + 1}`}
										/>
									)}
								</div>
							)
						)}
					</div>
				);

			default:
				return null;
		}
	};

	const handleMethodClick = (methodKey: string) => {
		setMethod(methodKey); // Update the method state
		setSelectedOption(null); // Reset selectedOption when method changes
		setExpandedMethod(expandedMethod === methodKey ? null : methodKey);
	};

	const handleOptionSelect = async (option: MethodOption) => {
		setSelectedOption(option);
		setInputType(option.inputType);

		// Only fetch MATLAB code for code input types
		if (option.inputType === 'code') {
			try {
				const response = await fetch(
					`http://localhost:5000/get-matlab-code/${option.id}`
				);
				const data = await response.json();

				if (data.success) {
					setInput(data.code); // Set the input to the MATLAB code
					setStatus('Code MATLAB chargé');
				} else {
					console.error(
						'Erreur lors du chargement du code MATLAB:',
						data.error
					);
					setStatus(
						`Erreur lors du chargement du code MATLAB : ${data.error}`
					);
				}
			} catch (error) {
				console.error(
					'Erreur lors du chargement du code MATLAB:',
					error
				);
				setStatus('Erreur lors du chargement du code MATLAB');
			}
		}

		if (window.innerWidth < 768) {
			setIsSidebarOpen(false);
		}
	};

	const renderSidebarContent = () => (
		<nav className='p-2 scrollbar-hide overflow-y-auto h-[calc(100%-4rem)]'>
			{Object.entries(methodConfigs).map(([key, config]) => (
				<div
					key={key}
					className='mb-2'
				>
					<button
						onClick={() => handleMethodClick(key)}
						className={`w-full text-left p-4 rounded-lg transition-all duration-200 ${
							expandedMethod === key
								? 'bg-[#21262d]'
								: 'hover:bg-[#21262d]'
						}`}
					>
						<div className='flex items-center justify-between'>
							<div className='flex items-center gap-2'>
								{config.type === 'code' ? (
									<Code2 className='w-4 h-4' />
								) : (
									<Terminal className='w-4 h-4' />
								)}
								<div className='font-medium'>
									{config.label}
								</div>
							</div>
							<ChevronDown
								className={`w-4 h-4 transform transition-transform ${
									expandedMethod === key ? 'rotate-180' : ''
								}`}
							/>
						</div>
					</button>

					{/* Options Panel */}
					<div
						className={`overflow-y-auto scrollbar-hide transition-all duration-300 ${
							expandedMethod === key
								? 'max-h-[500px] opacity-100'
								: 'max-h-0 opacity-0'
						}`}
					>
						{config.options.map((option) => (
							<button
								key={option.id}
								onClick={() => handleOptionSelect(option)}
								className={`w-full text-left p-3 pl-8 rounded-lg mt-1 transition-colors ${
									selectedOption?.id === option.id
										? 'bg-[#0d47a1] text-white'
										: 'hover:bg-[#21262d] text-[#8b949e]'
								}`}
							>
								<div className='font-medium'>
									{option.label}
								</div>
								<div className='text-sm mt-1 opacity-75'>
									{option.description}
								</div>
							</button>
						))}
					</div>
				</div>
			))}
		</nav>
	);

	return (
		<div className='min-h-screen bg-[#0d1117] text-[#c9d1d9] flex'>
			{/* Sidebar */}
			<div
				className={`fixed left-0 top-0 h-full bg-[#161b22] border-r border-[#30363d] w-72 transform transition-transform duration-300 ease-in-out z-20 
        ${isSidebarOpen ? 'translate-x-0' : '-translate-x-full'}`}
			>
				<div className='p-4 border-b border-[#30363d] flex items-center justify-between'>
					<h2 className='text-lg font-semibold flex items-center gap-2'>
						<Terminal className='w-5 h-5' />
						Méthodes d'analyse
					</h2>
					<button
						onClick={() => setIsSidebarOpen(!isSidebarOpen)}
						className='p-1.5 hover:bg-[#21262d] rounded-lg transition-colors'
					>
						{isSidebarOpen ? (
							<X className='w-5 h-5' />
						) : (
							<Menu className='w-5 h-5' />
						)}
					</button>
				</div>
				{renderSidebarContent()}
			</div>

			{/* Main Content */}
			<div
				className={`flex-1 transition-all duration-300 ${
					isSidebarOpen ? 'ml-72' : 'ml-0'
				}`}
			>
				<div className='max-w-full mx-auto px-4 py-6'>
					<header className='bg-gradient-to-r from-[#1a237e] to-[#0d47a1] p-6 rounded-xl shadow-lg mb-8'>
						<div className='flex items-center justify-between mb-4'>
							<div className='flex items-center gap-2'>
								<Terminal className='w-8 h-8 text-white' />
								<h1 className='text-3xl font-bold text-white'>
									Interface d'analyse numérique
									électromagnétique
								</h1>
								<button
									onClick={() =>
										setIsSidebarOpen(!isSidebarOpen)
									}
									className='p-2 hover:bg-[#21262d] rounded-lg transition-colors ml-4'
								>
									{isSidebarOpen ? (
										<X className='w-5 h-5 text-white' />
									) : (
										<Menu className='w-5 h-5 text-white' />
									)}
								</button>
							</div>
						</div>
						{method && (
							<p className='text-gray-200 mt-2'>
								{
									methodConfigs[
										method as keyof typeof methodConfigs
									].description
								}
							</p>
						)}
					</header>

					<div className='grid grid-cols-1 lg:grid-cols-2 gap-6'>
						<div className='bg-[#161b22] p-6 rounded-xl border border-[#30363d]'>
							<div className='flex items-center justify-between mb-4'>
								<h2 className='text-xl font-semibold flex items-center gap-2'>
									{inputType === 'code' ? (
										<Code2 className='w-5 h-5' />
									) : (
										<Hash className='w-5 h-5' />
									)}
									{inputType === 'code'
										? 'Entrée de Code MATLAB'
										: 'Entrée Numérique'}
								</h2>
								{/* Font size and fullscreen controls */}
								<div className='flex items-center gap-2 mb-2'>
									<button
										onClick={() =>
											setFontSize(
												Math.max(10, fontSize - 2)
											)
										}
										className='p-2 hover:bg-gray-700 rounded-lg'
										title='Decrease font size'
									>
										A-
									</button>
									<button
										onClick={() =>
											setFontSize(
												Math.min(24, fontSize + 2)
											)
										}
										className='p-2 hover:bg-gray-700 rounded-lg'
										title='Increase font size'
									>
										A+
									</button>
									<button
										onClick={() =>
											setIsCodeFullscreen(
												!isCodeFullscreen
											)
										}
										className='p-2 hover:bg-gray-700 rounded-lg'
										title={
											isCodeFullscreen
												? 'Minimize'
												: 'Maximize'
										}
									>
										{isCodeFullscreen ? (
											<Minimize2 size={20} />
										) : (
											<Maximize2 size={20} />
										)}
									</button>
								</div>
							</div>
							<div className='relative bg-[#0d1117] rounded-lg'>
								{renderInput()}
								<div
									ref={resizeRef}
									className='absolute bottom-0 left-0 right-0 h-2 cursor-row-resize bg-[#30363d] rounded-b-lg opacity-0 hover:opacity-100 transition-opacity'
									onMouseDown={startResize}
								/>
							</div>
							<div className='flex gap-4 mt-4'>
								<button
									onClick={executeCode}
									className='flex items-center gap-2 px-4 py-2 bg-gradient-to-r from-[#1a237e] to-[#0d47a1] text-white rounded-lg hover:shadow-lg transition-all duration-300 hover:-translate-y-1'
								>
									<Play className='w-4 h-4' />
									Exécuter
								</button>
								<button
									onClick={clearInput}
									className='flex items-center gap-2 px-4 py-2 bg-[#21262d] text-[#c9d1d9] rounded-lg hover:bg-[#30363d] transition-all duration-300'
								>
									<Trash2 className='w-4 h-4' />
									Effacer
								</button>
							</div>
							<div className='mt-4 p-2 bg-[#0d1117] rounded-lg text-sm text-[#8b949e]'>
								Statut: {status}
							</div>
						</div>

						<div
							className={`bg-[#161b22] p-6 rounded-xl border border-[#30363d] ${
								isFullscreen
									? 'fixed inset-4 z-50 overflow-auto'
									: ''
							}`}
						>
							<div className='flex items-center justify-between mb-4'>
								<h2 className='text-xl font-semibold flex items-center gap-2'>
									<Activity className='w-5 h-5' />
									Résultats
								</h2>
								<button
									onClick={() =>
										setIsFullscreen(!isFullscreen)
									}
									className='p-2 hover:bg-[#21262d] rounded-lg transition-colors'
								>
									{isFullscreen ? (
										<Minimize2 className='w-5 h-5' />
									) : (
										<Maximize2 className='w-5 h-5' />
									)}
								</button>
							</div>
							<div
								className={`${
									isFullscreen
										? 'h-[calc(100%-4rem)]'
										: 'h-96'
								} bg-[#0d1117] rounded-lg overflow-hidden`}
							>
								{renderOutput()}
							</div>
						</div>
					</div>

					<div className='mt-8 bg-[#161b22] p-6 rounded-xl border border-[#30363d]'>
						<h2 className='text-xl font-semibold mb-4 flex items-center gap-2'>
							<GitMerge className='w-5 h-5' />
							Commentaires
						</h2>
						<textarea
							value={comments}
							onChange={(e) => setComments(e.target.value)}
							className='w-full h-32 bg-[#0d1117] text-[#c9d1d9] border border-[#30363d] rounded-lg p-4 resize-none focus:ring-2 focus:ring-[#58a6ff] focus:border-transparent'
							placeholder='Ajouter vos commentaires ou notes ici...'
						/>
					</div>
				</div>
			</div>

			{/* Overlay for mobile */}
			{isSidebarOpen && (
				<div
					className='fixed inset-0 bg-black bg-opacity-50 z-10 md:hidden'
					onClick={() => setIsSidebarOpen(false)}
				/>
			)}
		</div>
	);
}

export default App;
